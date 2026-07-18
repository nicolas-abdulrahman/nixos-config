 { config, lib, pkgs, ... }:

# NOTE: this is a Home Manager module (it produces home.packages and
# systemd.user.services), not a plain NixOS module. Import it from your
# home.nix / flake's home-manager config, not from configuration.nix.

with lib;

let
  cfgProg = config.programs.openhands;
  cfgServ = config.services.openhands;

  # Rendered once at build time into the immutable Nix store, e.g.
  # /nix/store/<hash>-openhands-config.toml
  storeConfig = pkgs.writeText "openhands-config.toml" cfgProg.configText;

  openhands-runner = pkgs.writeShellScriptBin "openhands" ''
    set -euo pipefail

    WORKSPACE_BASE="${cfgProg.workspaceDir}"
    WORKSPACE_BASE=$(eval echo "$WORKSPACE_BASE")
    mkdir -p "$WORKSPACE_BASE"

    # config.toml itself is placed by home.file below (activation-time,
    # not run-time) — see `config` block at the bottom of this module.

    # --- 2. Resolve the LLM API key ---
    API_KEY_NAME="${cfgProg.llm.apiKey}"
    API_KEY_VAL=""
    if [ -n "$API_KEY_NAME" ]; then
      if env | grep -q "^''${API_KEY_NAME}="; then
        API_KEY_VAL=$(printenv "$API_KEY_NAME")
        echo "✅ API key loaded from \$$API_KEY_NAME"
      else
        echo "⚠️  '$API_KEY_NAME' isn't an exported env var — treating it as a literal key"
        API_KEY_VAL="$API_KEY_NAME"
      fi
    fi

    # --- 3. Sandbox toggle ---
    USE_DOCKER=true
    ARGS=()
    for arg in "$@"; do
      if [ "$arg" = "--no-docker" ]; then
        USE_DOCKER=false
      else
        ARGS+=("$arg")
      fi
    done

    export LLM_MODEL="${cfgProg.llm.model}"
    export LLM_API_KEY="$API_KEY_VAL"
    export WORKSPACE_BASE="$WORKSPACE_BASE"
    export WORKSPACE_MOUNT_PATH="$WORKSPACE_BASE"
    export OPENHANDS_SUPPRESS_BANNER="1"
    export LLM_TEMPERATURE="0.0"
    export MAX_ITERATIONS="100"

    if [ "$USE_DOCKER" = false ]; then
      echo "Running OpenHands sandbox natively (no Docker)..."
      export RUNTIME="local"
    else
      echo "Running OpenHands sandbox in Docker..."
      export RUNTIME="docker"
      export PATH="${cfgProg.package}/bin:$PATH"
    fi

    # --- 4. Actually persist LLM settings to disk ---
    # Confirmed against the current CLI docs: OpenHands persists agent
    # settings (including the LLM block) to ~/.openhands/agent_settings.json
    # as { "llm": { "model": ..., "api_key": ... } } — nested under "llm",
    # not flat llm_model/llm_api_key keys (that was the old v0 schema, and
    # the earlier version of this wrapper guessed wrong). Written as a
    # real, writable file on every launch, not a Nix-store symlink — and
    # merged with jq rather than overwritten outright, so it doesn't wipe
    # out condenser/other settings configured via the in-app /settings
    # screen between launches.
    mkdir -p "$HOME/.openhands"
    AGENT_SETTINGS="$HOME/.openhands/agent_settings.json"
    LLM_JSON=$(${pkgs.jq}/bin/jq -n --arg model "$LLM_MODEL" --arg key "$API_KEY_VAL" \
      '{llm: {model: $model, api_key: $key}}')
    if [ -f "$AGENT_SETTINGS" ]; then
      MERGED=$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$AGENT_SETTINGS" <(echo "$LLM_JSON") 2>/dev/null) || MERGED="$LLM_JSON"
    else
      MERGED="$LLM_JSON"
    fi
    echo "$MERGED" > "$AGENT_SETTINGS"
    chmod 600 "$AGENT_SETTINGS"

    # --- 5. The actual fix for the setup dialog ---
    # Without --override-with-envs, OpenHands ignores LLM_MODEL/LLM_API_KEY
    # entirely and falls back to ~/.openhands/settings.json. On a fresh
    # install that file doesn't exist, so it opens the interactive
    # first-run wizard instead of starting. This flag forces it to trust
    # the env vars above instead.
    ARGS=("--override-with-envs" "''${ARGS[@]}")

    echo "🚀 Launching OpenHands..."
    exec ${pkgs.uv}/bin/uvx --python 3.12 openhands "''${ARGS[@]}"
  '';

in {
  options = {
    programs.openhands = {
      enable = mkEnableOption "OpenHands AI Developer CLI";

      package = mkOption {
        type = types.package;
        default = pkgs.docker;
        description = ''
          The docker package used for the *sandbox* the agent executes
          commands in. Not related to running OpenHands itself — the CLI
          now ships as a plain uv/uvx Python package, not a container
          image, so there's no separate "app image" to configure.
        '';
      };

      workspaceDir = mkOption {
        type = types.str;
        default = "$HOME/workspace";
        description = "The absolute host path mounted as the agent's work directory.";
      };

      configText = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Raw TOML written into the Nix store at build time and symlinked
          to ~/.openhands/config.toml at runtime. Current OpenHands treats
          this as legacy config (security analyzer, agent-level settings,
          etc.) — LLM provider/model/key are handled separately via
          `programs.openhands.llm` below, passed as env vars combined with
          --override-with-envs, since the current CLI mostly ignores
          config.toml for those specifically.
        '';
      };

      llm = {
        model = mkOption {
          type = types.str;
          default = "anthropic/claude-sonnet-4-5-20250929";
          description = ''
            A LiteLLM-style "<provider>/<model>" slug, not a bare model
            name — e.g. "anthropic/claude-sonnet-4-5-20250929" for direct
            Anthropic, or "openhands/<model>" if you're using OpenHands'
            own hosted LLM proxy instead of your own API key.
          '';
        };

        apiKey = mkOption {
          type = types.str;
          default = "LLM_KEY";
          description = "Either a literal API key, or the name of an environment variable to read at runtime.";
        };
      };
    };

    services.openhands = {
      enable = mkEnableOption "OpenHands AI Developer background service";
    };
  };

  config = mkMerge [
    (mkIf cfgProg.enable {
      home.packages = [ openhands-runner ];

      # Symlinks ~/.openhands/config.toml -> the Nix store path at
      # activation time, so it's there as soon as `home-manager switch`
      # finishes — no need to have run `openhands` first.
      home.file.".openhands/config.toml" = mkIf (cfgProg.configText != "") {
        source = storeConfig;
      };
    })

    (mkIf cfgServ.enable {
      programs.openhands.enable = true;

      systemd.user.services.openhands = {
        Unit = {
          Description = "OpenHands AI Agent Workspace";
        };

        Service = {
          # NOTE: as written this launches the interactive TUI with no
          # arguments, under systemd, with no TTY attached — it will not
          # behave like a normal terminal session. If the goal is an
          # always-on background agent, you likely want this to invoke
          # `openhands --headless -t "..."` (or -f a task file) instead.
          # Left as-is here since that depends on what you want the
          # service to actually do — happy to wire that up specifically.
          ExecStart = "${openhands-runner}/bin/openhands";
          Restart = "on-failure";
          RestartSec = "10s";
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ];
}

