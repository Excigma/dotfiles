{
  pkgs,
  lib,
  self,
  user,
  ...
}:
{
  imports = [
    ./base.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/gnome-extensions.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/ghostty.nix
  ];

  home = {
    # Needed to use gnome-extensions
    extraActivationPath = with pkgs; [ gnome-shell ];
    activation = {
      symlinkTemporaryFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Create RAM disk directories for temporary files and symlink them to the home directory.
        run mkdir -p /tmp/${user}/Screencasts
        run mkdir -p /tmp/${user}/Screenshots
        run mkdir -p /tmp/${user}/Temporary

        run ln -sf /tmp/${user}/Screencasts /home/${user}/Videos
        run ln -sf /tmp/${user}/Screenshots /home/${user}/Pictures
        run ln -sf /tmp/${user}/Temporary /home/${user}
      '';
      # Toggle the Night Theme Switcher extension to ensure correct theme is applied after activation.
      setTheme = lib.hm.dag.entryAfter [ "installPackages" ] ''
        run gnome-extensions disable nightthemeswitcher@romainvigier.fr && gnome-extensions enable nightthemeswitcher@romainvigier.fr
      '';
    };

    file = {
      "face.jpg".source = "${self}/.local/share/backgrounds/Profile.jpg";
      ".local" = {
        source = "${self}/.local";
        recursive = true;
      };
    };
  };

  # Hide desktop entries for applications that will predominantly be used in a terminal or via a different interface.
  xdg.desktopEntries = builtins.listToAttrs (
    map
      (name: {
        inherit name;
        value = {
          inherit name;
          noDisplay = true;
        };
      })
      [
        "xterm"
        "xpra-gui"
        "scrcpy"
        "PuTTY Terminal Emulator"
      ]
  );

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  services = {
    mpris-proxy.enable = true;
  };
}
