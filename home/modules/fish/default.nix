{ config, lib, pkgs, osConfig, ... }:

let
in
{
  programs.fish = {
    generateCompletions = false;
    enable = true;

    # Include tide if you aren't already managing your plugins elsewhere
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];

    functions = {
        dev = ''
        if test (count $argv) -eq 0
            echo "Usage: dev <flake-output>"
            return 1
        end

        nix develop "/etc/nixos#$argv[1]" $argv[2..]
      '';

      y = ''
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
  '';
      h = ''
        set -l user ${config.home.username}
        set -l host  ${osConfig.hostname}
        set -l flakepath "/etc/nixos" # Strongly recommend an absolute path here!


        echo "🚀 Building Home Manager for '$user' on '$host'... (totally not ai :D)"

        # Build without the symlink, and capture the output path
        set -l build_path (nix build "$flakepath#nixosConfigurations.$host.config.home-manager.users.$user.home.activationPackage" --no-link --print-out-paths)

        # Check if the build_path was successfully generated
        if test $status -eq 0
            echo "✨ Activating..."
            $build_path/activate
        else
            echo "❌ Build failed."
            return 1
        end
      '';
    };

    interactiveShellInit = ''
          set -g fish_greeting

      # Tide config, set directly — no `tide configure` call, no wizard,
      # no psub. This is the exact variable set tide's own --auto configurator
      # produces for: --style=Classic --prompt_colors='True color'
      # --classic_prompt_color=Dark --show_time='12-hour format'
      # --classic_prompt_separators=Angled --powerline_prompt_heads=Slanted
      # --powerline_prompt_tails=Sharp --powerline_prompt_style='Two lines, character and frame'
      # --prompt_connection=Dotted --powerline_right_prompt_frame=Yes
      # --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Compact
      # --icons='Many icons' --transient=No
      set -g tide_aws_bg_color "303030"
      set -g tide_aws_color "FF9900"
      set -g tide_aws_icon \uf270
      set -g tide_bun_bg_color "303030"
      set -g tide_bun_color "FBF0DF"
      set -g tide_bun_icon \U000f0cd3
      set -g tide_character_color "5FD700"
      set -g tide_character_color_failure "FF0000"
      set -g tide_character_icon \u276f
      set -g tide_character_vi_icon_default \u276e
      set -g tide_character_vi_icon_replace \u25b6
      set -g tide_character_vi_icon_visual "V"
      set -g tide_cmd_duration_bg_color "303030"
      set -g tide_cmd_duration_color "87875F"
      set -g tide_cmd_duration_decimals "0"
      set -g tide_cmd_duration_icon \uf252
      set -g tide_cmd_duration_threshold "3000"
      set -g tide_context_always_display "false"
      set -g tide_context_bg_color "303030"
      set -g tide_context_color_default "D7AF87"
      set -g tide_context_color_root "D7AF00"
      set -g tide_context_color_ssh "D7AF87"
      set -g tide_context_hostname_parts "1"
      set -g tide_crystal_bg_color "303030"
      set -g tide_crystal_color "FFFFFF"
      set -g tide_crystal_icon \ue62f
      set -g tide_direnv_bg_color "303030"
      set -g tide_direnv_bg_color_denied "303030"
      set -g tide_direnv_color "D7AF00"
      set -g tide_direnv_color_denied "FF0000"
      set -g tide_direnv_icon \u25bc
      set -g tide_distrobox_bg_color "303030"
      set -g tide_distrobox_color "FF00FF"
      set -g tide_distrobox_icon \U000f01a7
      set -g tide_docker_bg_color "303030"
      set -g tide_docker_color "2496ED"
      set -g tide_docker_default_contexts "default" "colima"
      set -g tide_docker_icon \uf308
      set -g tide_elixir_bg_color "303030"
      set -g tide_elixir_color "4E2A8E"
      set -g tide_elixir_icon \ue62d
      set -g tide_gcloud_bg_color "303030"
      set -g tide_gcloud_color "4285F4"
      set -g tide_gcloud_icon \U000f02ad
      set -g tide_git_bg_color "303030"
      set -g tide_git_bg_color_unstable "303030"
      set -g tide_git_bg_color_urgent "303030"
      set -g tide_git_color_branch "5FD700"
      set -g tide_git_color_conflicted "FF0000"
      set -g tide_git_color_dirty "D7AF00"
      set -g tide_git_color_operation "FF0000"
      set -g tide_git_color_staged "D7AF00"
      set -g tide_git_color_stash "5FD700"
      set -g tide_git_color_untracked "00AFFF"
      set -g tide_git_color_upstream "5FD700"
      set -g tide_git_icon \uf1d3
      set -g tide_git_truncation_length "24"
      set -g tide_git_truncation_strategy ""
      set -g tide_go_bg_color "303030"
      set -g tide_go_color "00ACD7"
      set -g tide_go_icon \ue627
      set -g tide_java_bg_color "303030"
      set -g tide_java_color "ED8B00"
      set -g tide_java_icon \ue256
      set -g tide_jobs_bg_color "303030"
      set -g tide_jobs_color "5FAF00"
      set -g tide_jobs_icon \uf013
      set -g tide_jobs_number_threshold "1000"
      set -g tide_kubectl_bg_color "303030"
      set -g tide_kubectl_color "326CE5"
      set -g tide_kubectl_icon \U000f10fe
      set -g tide_left_prompt_frame_enabled "true"
      set -g tide_left_prompt_items "os" "pwd" "git" "newline" "character"
      set -g tide_left_prompt_prefix \ue0b2
      set -g tide_left_prompt_separator_diff_color \ue0b0
      set -g tide_left_prompt_separator_same_color \ue0b1
      set -g tide_left_prompt_suffix \ue0bc
      set -g tide_nix_shell_bg_color "303030"
      set -g tide_nix_shell_color "7EBAE4"
      set -g tide_nix_shell_icon \uf313
      set -g tide_node_bg_color "303030"
      set -g tide_node_color "44883E"
      set -g tide_node_icon \ue24f
      set -g tide_os_bg_color "303030"
      set -g tide_os_color "EEEEEE"
      set -g tide_os_icon \uf31b
      set -g tide_php_bg_color "303030"
      set -g tide_php_color "617CBE"
      set -g tide_php_icon \ue608
      set -g tide_private_mode_bg_color "303030"
      set -g tide_private_mode_color "FFFFFF"
      set -g tide_private_mode_icon \U000f05f9
      set -g tide_prompt_add_newline_before "false"
      set -g tide_prompt_color_frame_and_connection "808080"
      set -g tide_prompt_color_separator_same_color "949494"
      set -g tide_prompt_icon_connection \u00b7
      set -g tide_prompt_min_cols "34"
      set -g tide_prompt_pad_items "true"
      set -g tide_prompt_transient_enabled "false"
      set -g tide_pulumi_bg_color "303030"
      set -g tide_pulumi_color "F7BF2A"
      set -g tide_pulumi_icon \uf1b2
      set -g tide_pwd_bg_color "303030"
      set -g tide_pwd_color_anchors "00AFFF"
      set -g tide_pwd_color_dirs "0087AF"
      set -g tide_pwd_color_truncated_dirs "8787AF"
      set -g tide_pwd_icon \uf07c
      set -g tide_pwd_icon_home \uf015
      set -g tide_pwd_icon_unwritable \uf023
      set -g tide_pwd_markers ".bzr" ".citc" ".git" ".hg" ".node-version" ".python-version" ".ruby-version" ".shorten_folder_marker" ".svn" ".terraform" "bun.lockb" "Cargo.toml" "composer.json" "CVS" "go.mod" "package.json" "build.zig"
      set -g tide_python_bg_color "303030"
      set -g tide_python_color "00AFAF"
      set -g tide_python_icon \U000f0320
      set -g tide_right_prompt_frame_enabled "true"
      set -g tide_right_prompt_items "status" "cmd_duration" "context" "jobs" "direnv" "bun" "node" "python" "rustc" "java" "php" "pulumi" "ruby" "go" "gcloud" "kubectl" "distrobox" "toolbox" "terraform" "aws" "nix_shell" "crystal" "elixir" "zig" "time"
      set -g tide_right_prompt_prefix \ue0ba
      set -g tide_right_prompt_separator_diff_color \ue0b2
      set -g tide_right_prompt_separator_same_color \ue0b3
      set -g tide_right_prompt_suffix \ue0b0
      set -g tide_ruby_bg_color "303030"
      set -g tide_ruby_color "B31209"
      set -g tide_ruby_icon \ue23e
      set -g tide_rustc_bg_color "303030"
      set -g tide_rustc_color "F74C00"
      set -g tide_rustc_icon \ue7a8
      set -g tide_shlvl_bg_color "303030"
      set -g tide_shlvl_color "d78700"
      set -g tide_shlvl_icon \uf120
      set -g tide_shlvl_threshold "1"
      set -g tide_status_bg_color "303030"
      set -g tide_status_bg_color_failure "303030"
      set -g tide_status_color "5FAF00"
      set -g tide_status_color_failure "D70000"
      set -g tide_status_icon \u2714
      set -g tide_status_icon_failure \u2718
      set -g tide_terraform_bg_color "303030"
      set -g tide_terraform_color "844FBA"
      set -g tide_terraform_icon \U000f1062
      set -g tide_time_bg_color "303030"
      set -g tide_time_color "5F8787"
      set -g tide_time_format "%r"
      set -g tide_toolbox_bg_color "303030"
      set -g tide_toolbox_color "613583"
      set -g tide_toolbox_icon \ue24f
      set -g tide_vi_mode_bg_color_default "303030"
      set -g tide_vi_mode_bg_color_insert "303030"
      set -g tide_vi_mode_bg_color_replace "303030"
      set -g tide_vi_mode_bg_color_visual "303030"
      set -g tide_vi_mode_color_default "949494"
      set -g tide_vi_mode_color_insert "87AFAF"
      set -g tide_vi_mode_color_replace "87AF87"
      set -g tide_vi_mode_color_visual "FF8700"
      set -g tide_vi_mode_icon_default "D"
      set -g tide_vi_mode_icon_insert "I"
      set -g tide_vi_mode_icon_replace "R"
      set -g tide_vi_mode_icon_visual "V"
      set -g tide_zig_bg_color "303030"
      set -g tide_zig_color "F7A41D"
      set -g tide_zig_icon \ue6a9



    '';
  };
}
