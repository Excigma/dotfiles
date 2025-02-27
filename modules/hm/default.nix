{ user, self, ... }:
let inherit (builtins) filter attrNames readDir;
in {
  imports = map (file: "${./.}/${file}") (filter (x: x != "default.nix") (attrNames (readDir ./.)));

  home = {
    username = user;
    homeDirectory = "/home/${user}";

    file = {
      "face.jpg".source = "${self}/.local/share/backgrounds/Profile.jpg";
      ".local" = {
        source = "${self}/.local";
        recursive = true;
      };
      ".config" = {
        source = "${self}/.config";
        recursive = true;
      };
    };

    # It‘s perfectly fine and recommended to leave this value
    # at the release version of the first install of this system.
    stateVersion = "24.11";
  };

  # GNOME will overwrite the symlink and break things
  xdg.mimeApps.enable = false;

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "dark:dark-theme,light:light-theme";
        term = "xterm-256color";
        confirm-close-surface = false;
        shell-integration-features = true;
        keybind = [ "ctrl+t=new_tab" "ctrl+w=close_tab" ];
      };
      themes = {
        light-theme = {
          palette = [
            "0=#000000"
            "1=#AA3731"
            "2=#448C27"
            "3=#CB9000"
            "4=#325CC0"
            "5=#7A3E9D"
            "6=#0083B2"
            "7=#BBBBBB"
            "8=#777777"
            "9=#F05050"
            "10=#60CB00"
            "11=#FFBC5D"
            "12=#007ACC"
            "13=#E64CE6"
            "14=#00AACB"
            "15=#FFFFFF"
          ];
          background = "#F7F7F7";
          foreground = "#434343";
          cursor-color = "#434343";
          cursor-text = "#F7F7F7";
          selection-background = "#BBBBBB";
          selection-foreground = "#434343";
        };
        dark-theme = {
          palette = [
            "0=#0E1415"
            "1=#e25d56"
            "2=#73ca50"
            "3=#e9bf57"
            "4=#4a88e4"
            "5=#915caf"
            "6=#23acdd"
            "7=#f0f0f0"
            "8=#777777"
            "9=#f36868"
            "10=#88db3f"
            "11=#f0bf7a"
            "12=#6f8fdb"
            "13=#e987e9"
            "14=#4ac9e2"
            "15=#FFFFFF"
          ];
          background = "#1e1e1e";
          foreground = "#CECECE";
          cursor-color = "#CECECE";
          cursor-text = "#0E1415";
          selection-background = "#f0f0f0";
          selection-foreground = "#1e1e1e";
        };
      };
    };
    git = {
      enable = true;
      userName = "Excigma";
      userEmail = "git@excigma.xyz";
    };
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
