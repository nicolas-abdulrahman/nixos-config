
{ config, pkgs, inputs, lib, hypr ? false, full ? false, ... }:
let
  lazy = if full then
  (pkgs.lazygit.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        cat > pkg/gui/information_panel.go << 'GOEOF'
        package gui

        import (
        	"os/exec"
        	"strings"

        	"github.com/jesseduffield/lazygit/pkg/gui/style"
        	"github.com/jesseduffield/lazygit/pkg/utils"
        )

        func (gui *Gui) informationStr() string {
        	if activeMode, ok := gui.helpers.Mode.GetActiveMode(); ok {
        		return activeMode.InfoLabel()
        	}

        	if name, ok := gitUserName(); ok {
        		return style.FgCyan.Sprint(name)
        	}

        	return gui.Config.GetVersion()
        }

        func gitUserName() (string, bool) {
        	out, err := exec.Command("git", "config", "user.name").Output()
        	if err != nil {
        		return "", false
        	}
        	name := strings.TrimSpace(string(out))
        	if name == "" {
        		return "", false
        	}
        	return name, true
        }

        func (gui *Gui) handleInfoClick() error {
        	if !gui.g.Mouse {
        		return nil
        	}

        	view := gui.Views.Information

        	cx, _ := view.Cursor()
        	width := view.Width()

        	if activeMode, ok := gui.helpers.Mode.GetActiveMode(); ok {
        		if width-cx > utils.StringWidth(gui.c.Tr.ResetInParentheses) {
        			return nil
        		}
        		return activeMode.Reset()
        	}

        	return nil
        }
        GOEOF
      '';
    }))else
    pkgs.lazygit;
in
{
home.packages = with pkgs; 
  # Essentials: Daily utilities, CLI tools, and networking
  [
      ddcutil
      lazy
    zoxide broot nnn kitty st xclip brightnessctl pavucontrol aseprite
    warp-terminal git-credential-manager android-tools arp-scan nmap
  ] ++ 
  # Hyprland: Window manager specific tools
  (lib.optionals hypr [
    grimblast mako waybar eww hyprpaper hyprlock hypridle 
    wf-recorder hyprsunset swayimg xwayland wl-clipboard cliphist
  ]) ++ 
  # Full: Heavy GUI apps, media, and office software
  (lib.optionals full [
    # Browsers & Media
    google-chrome brave thunderbird spotify qbittorrent
    obs-studio audacity blender krita gimp
    
    # Utilities & Office
    wireshark metabase texliveFull prismlauncher protonup-qt 
    libreoffice-qt6 lutris waydroid steam-run steamcmd 
    gamescope weston blockbench equicord steam
  ]);

    programs.vscode = lib.mkIf full {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        editorconfig.editorconfig
        dbaeumer.vscode-eslint
        stylelint.vscode-stylelint
        zainchen.json
      ];
    };


}
