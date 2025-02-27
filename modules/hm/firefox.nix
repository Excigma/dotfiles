{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
    profiles."dev-edition-default" = {
      id = 0;
      isDefault = true;
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.discovery.enabled" = false;
        "browser.display.use_system_colors" = true;
        "browser.startup.homepage" = "https://excigma.xyz/newtab";
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.trending" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "sidebar.verticalTabs" = true;
        "extensions.pocket.enabled" = false;
      };

      search = {
        force = true;
        engines = {
          "Home Manager" = {
            urls = [{
              template = "https://home-manager-options.extranix.com";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
                {
                  name = "release";
                  value = "release-24.11";
                }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "!homeopt" "!homeopts" ];
          };
          "MyNixOS" = {
            urls = [{
              template = "https://mynixos.com/search";
              params = [{
                name = "q";
                value = "{searchTerms}";
              }];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = [ "!mynix" "!mynixos" ];
          };
          "NixOS Wiki" = { # Temporary fix
            urls = [{
              template = "https://wiki.nixos.org/w/index.php";
              params = [{
                name = "search";
                value = "{searchTerms}";
              }];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "!nix" "!nixos" ];
          };
          "NixOS Options" = { # Temporary fix
            urls = [{
              template = "https://search.nixos.org/options";
              params = [{
                name = "query";
                value = "{searchTerms}";
              }];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "!nixopt" "!nixopts" ];
          };
        };
      };
    };
  };
}
