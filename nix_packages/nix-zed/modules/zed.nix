{ config, lib, pkgs, ... }:

let
  cfg = config.programs.zed;
  zedLib = import ../lib { inherit lib pkgs; };

  # Convert an attrset to Zed's JSONC settings file
  settingsFormat = pkgs.formats.json { };
in

{
  # ---------------------------------------------------------------------------
  # Options
  # ---------------------------------------------------------------------------
  options.programs.zed = {
    enable = lib.mkEnableOption "Zed editor";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zed-editor;
      defaultText = lib.literalExpression "pkgs.zed-editor";
      description = "The Zed package to install.";
    };

    # --- Extensions -----------------------------------------------------------
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "toml" "nix" "rust" "dockerfile" "html" ];
      description = ''
        List of Zed extension IDs to install automatically.
        These map to the extension slugs shown in the Zed extension marketplace.
        Zed will auto-install them on first launch via `auto_install_extensions`.
      '';
    };

    # --- Settings -------------------------------------------------------------
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = lib.literalExpression ''
        {
          theme = "One Dark";
          buffer_font_size = 14;
          ui_font_size = 15;
          vim_mode = false;
          tab_size = 2;
          format_on_save = "on";
          autosave = { after_delay = { milliseconds = 1000; }; };
        }
      '';
      description = ''
        Attribute set merged into `~/.config/zed/settings.json`.
        Extensions declared in `programs.zed.extensions` are injected here
        automatically — no need to set `auto_install_extensions` manually.
      '';
    };

    # --- Keymap ---------------------------------------------------------------
    keymap = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            context = "Editor";
            bindings = {
              "ctrl-shift-p" = "command_palette::Toggle";
              "ctrl-/" = "editor::ToggleComments";
            };
          }
        ]
      '';
      description = ''
        Custom keybindings written to `~/.config/zed/keymap.json`.
        Each entry is `{ context, bindings }`.
      '';
    };

    # --- LSP ------------------------------------------------------------------
    lsp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          binary = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Absolute path to the LSP binary. Use a store path from nixpkgs.";
            example = lib.literalExpression ''"''${pkgs.rust-analyzer}/bin/rust-analyzer"'';
          };

          settings = lib.mkOption {
            type = lib.types.attrs;
            default = { };
            description = "LSP-specific initialization options passed verbatim to Zed.";
          };
        };
      });
      default = { };
      example = lib.literalExpression ''
        {
          rust-analyzer = {
            binary = "''${pkgs.rust-analyzer}/bin/rust-analyzer";
            settings = {
              cargo.features = "all";
              procMacro.enable = true;
            };
          };
          nil = {
            binary = "''${pkgs.nil}/bin/nil";
            settings = {
              nix.flake.autoEvalInputs = true;
            };
          };
        }
      '';
      description = ''
        Per-LSP configuration.  `binary` pins the path to a Nix-managed binary;
        `settings` are passed as `initialization_options` to Zed.
        These are merged into the top-level `lsp` key in `settings.json`.
      '';
    };

    # --- Tasks ----------------------------------------------------------------
    tasks = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            label = "cargo build";
            command = "cargo";
            args = [ "build" ];
            env = { RUST_LOG = "debug"; };
          }
        ]
      '';
      description = ''
        Task definitions written to `~/.config/zed/tasks.json`.
      '';
    };

    extraKeymap = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Raw JSON string (array of objects) to be appended to keymap.json.";
      example = ''
        [
          {
            "context": "Editor",
            "bindings": { "ctrl-j": "editor::MoveDown" }
          }
        ]
      '';

    extraSettings = lib.mkOption {
         type = lib.types.str;
         default = "";
         description = "Raw JSON string to be merged into settings.json.";
         example = ''
           {
             "experimental.theme_overrides": {
               "background": "#000000"
             }
           }
         '';
  };

  # ---------------------------------------------------------------------------
  # Implementation
  # ---------------------------------------------------------------------------
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Build the final settings.json by merging user settings with generated
    # extension list and LSP binary paths.
    xdg.configFile."zed/settings.json".source =
      let
        # Auto-install extensions listed in options.extensions
        extensionAttrs =
          if cfg.extensions != [ ]
          then { auto_install_extensions = zedLib.extensionListToAttrs cfg.extensions; }
          else { };

        # Merge per-LSP binary paths into the `lsp` key
        lspAttrs =
          if cfg.lsp != { }
          then { lsp = zedLib.buildLspConfig cfg.lsp; }
          else { };

        finalSettings = lib.recursiveMerge [
          cfg.settings
          extensionAttrs
          lspAttrs
        ]
        ++ (if cfg.extraSettings!= "" then builtins.fromJSON cfg.extraKeymap else []);
      in
      settingsFormat.generate "zed-settings.json" finalSettings;

    # keymap.json
    xdg.configFile."zed/keymap.json" =
      let
        # Combine the Nix list with the parsed raw JSON list
        finalKeymap = cfg.keymap ++ (if cfg.extraKeymap != "" then builtins.fromJSON cfg.extraKeymap else []);
      in
      lib.mkIf (finalKeymap != [ ]) {
        source = settingsFormat.generate "zed-keymap.json" finalKeymap;
      };


    # tasks.json
    xdg.configFile."zed/tasks.json" = lib.mkIf (cfg.tasks != [ ]) {
      source = settingsFormat.generate "zed-tasks.json" cfg.tasks;
    };
  };
}
