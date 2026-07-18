{ pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;

    # Enterprise Policies apply extensions globally across ALL profiles at once
    policies = {
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # Dark Reader
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
      };
    };

    profiles = {
      nicolas-hugo = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://accounts.google.com/AccountChooser?continue=https://mail.google.com&Email=nicolas.hugo2001@gmail.com";
          "browser.search.suggest.enabled" = false;
          "devtools.theme" = "dark";
        };
      };

      # PROFILE 2: Nicolas Abdul Rahman (Work / Dev)
      nicolas-abdul = {
        id = 1;
        name = "work";
        settings = {
          "browser.startup.homepage" = "https://accounts.google.com/AccountChooser?continue=https://mail.google.com&Email=nicolas.abdul.rahman@gmail.com";
          "devtools.theme" = "dark";
        };
      };

      other= {
        id = 2;
        name = "other";
        settings = {
          "browser.startup.homepage" = "https://accounts.google.com/AccountChooser?continue=https://mail.google.com&Email=maxthedog1200@gmail.com";
          "privacy.trackingprotection.enabled" = true;
        };
      };
    };
  };
}
