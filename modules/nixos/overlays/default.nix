{ pkgs, self, ... }: {
  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };
      stable = import nixpkgs-stable { inherit (prev) config system; };

      cloudflared = (prev.cloudflared.override {
        buildGoModule = pkgs.buildGoModule.override {
          go = pkgs.buildPackages.go_1_23.overrideAttrs (old: {
            pname = "cloudflare-go";
            version = "1.22.5-devel-cf";

            src = pkgs.fetchFromGitHub {
              owner = "cloudflare";
              repo = "go";
              rev = "af19da5605ca11f85776ef7af3384a02a315a52b";
              hash = "sha256-6VT9CxlHkja+mdO1DeFoOTq7gjb3T5jcf2uf9TB/CkU=";
            };

            patches = map (patch:
              if (baseNameOf patch == "go_no_vendor_checks-1.23.patch") then ./go-no-vendor-1.22.patch else patch)
              old.patches;
          });
        };
      }).overrideAttrs { meta.broken = false; };

      sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/screen-capture.oga";
      });

      marble-shell-theme = prev.marble-shell-theme.overrideAttrs (oldAttrs: {
        patches = [
          (builtins.toFile "disable-taskbar-icon-background" ''
            diff --git a/theme/gnome-shell/.css/panel.css b/theme/gnome-shell/.css/panel.css
            index 43b478b..6c67062 100644
            --- a/theme/gnome-shell/.css/panel.css
            +++ b/theme/gnome-shell/.css/panel.css
            @@ -36,6 +36,13 @@
                 box-shadow: inset 0 0 0 1px BORDER-SHADOW;
             }

            +/* App icons taskbar - hide button background */
            +.panel-button.azTaskbar-BaseIcon {
            +    background-color: transparent !important;
            +    border: none !important;
            +    box-shadow: none !important;
            +}
            +
             .panel-button:hover,
             .panel-button:hover .clock,
             .panel-button:active,
          '')

          (builtins.toFile "fix-quick-settings-padding" ''
            diff --git a/theme/gnome-shell/.css/quick-settings.css b/theme/gnome-shell/.css/quick-settings.css
            index fcf8f86..e5f5c42 100644
            --- a/theme/gnome-shell/.css/quick-settings.css
            +++ b/theme/gnome-shell/.css/quick-settings.css
            @@ -2,7 +2,7 @@

             /* QS section */
             .quick-settings {
            -	padding: 15px;
            +	padding: 15px !important;
             	border-radius: 24px;
             }
          '')
        ];
      });

      go-10mb-video = pkgs.buildGoModule {
        pname = "10mb.video";
        version = "e5cd1ed583d6fce1e2552a91d48959f3243d341f";

        src = pkgs.fetchFromGitHub {
          owner = "ugjka";
          repo = "10mb.video";
          rev = "e5cd1ed583d6fce1e2552a91d48959f3243d341f";
          sha256 = "sha256-vYId1/sKz8DWjxbP5VmyzCEoBkSIxodgdfAsbUSdbKk=";
        };

        vendorHash = null;
        subPackages = [ "." ];
        buildInputs = with pkgs; [ ffmpeg fdk-aac-encoder ];

        meta = with pkgs.lib; {
          description = "Fit a video into a 10mb file (Discord nitro pls?)";
          homepage = "https://github.com/ugjka/10mb.video";
          license = licenses.mit;
          maintainers = [ ];
          platforms = platforms.all;
          mainProgram = pname;
        };
      };

      iriunwebcam = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "iriunwebcam";
        version = "2.8.4";
        meta.mainProgram = pname;
        nativeBuildInputs = with pkgs; [ autoPatchelfHook dpkg qt5.wrapQtAppsHook ];
        buildInputs = with pkgs; [ alsa-lib avahi libdrm libgcc libusbmuxd libsForQt5.qt5.qtbase ];
        unpackPhase = "dpkg-deb -x $src .";
        installPhase = ''
          mkdir -p $out

          cp -r etc $out/etc
          cp -r usr/local/bin $out/bin

          mkdir -p $out/share
          cp -r usr/share/* $out/share

          sed -i "s|Exec=.*|Exec=iriunwebcam|g" $out/share/applications/iriunwebcam.desktop
          chmod +x $out/bin/iriunwebcam
        '';
        src = pkgs.fetchurl {
          url = "http://iriun.gitlab.io/iriunwebcam-${version}.deb";
          hash = "sha256-4Et+X10fRbyyQcPjzQcXTR4WlXf0rWQlvdGwQip1T1o=";
        };
      };

      nautilus-python = prev.nautilus-python.overrideAttrs (old: {
        patches = [
          (builtins.toFile "single-path" ''
            diff --git a/src/nautilus-python.c b/src/nautilus-python.c
            index 6e230ba..291640f 100644
            --- a/src/nautilus-python.c
            +++ b/src/nautilus-python.c
            @@ -229,18 +229,8 @@ nautilus_python_check_all_directories(GTypeModule *module) {
                 dirs = g_list_append(dirs, g_strdup (prefix_extension_dir));
             
                 // Check all system data dirs 
            -    const gchar *const *temp = g_get_system_data_dirs();
            -    while (*temp != NULL) {
            -        gchar *dir = g_build_filename(*temp,
            -            "nautilus-python", "extensions", NULL);
            -        if (g_strcmp0(dir, prefix_extension_dir) != 0) {
            -            dirs = g_list_append(dirs, dir);
            -        } else {
            -            g_free (dir);
            -        }
            -
            -        temp++;
            -    }
            +    dirs = g_list_append(dirs, g_build_filename("/run", "current-system", "sw",
            +        "share", "nautilus-python", "extensions", NULL));
             
                 dirs = g_list_first(dirs);
                 while (dirs != NULL) {
          '')
        ] ++ old.patches or [ ];
      });

      power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (old: {
        # Disable tests, and they take a long time to run.
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dtests=false" ];
        patches = [
          (builtins.toFile "use-cool-platform-profile" ''
            diff --git a/src/ppd-driver-platform-profile.c b/src/ppd-driver-platform-profile.c
            index 28fc335..706ab82 100644
            --- a/src/ppd-driver-platform-profile.c
            +++ b/src/ppd-driver-platform-profile.c
            @@ -66,7 +66,7 @@ profile_to_acpi_platform_profile_value (PpdDriverPlatformProfile *self,
                   return "low-power";
                 return "quiet";
               case PPD_PROFILE_BALANCED:
            -    return "balanced";
            +    return "cool";
               case PPD_PROFILE_PERFORMANCE:
                 return "performance";
               }
            --
            2.48.1
          '')
        ] ++ old.patches or [ ];
      });

      openfreebuds = with pkgs.python3Packages;
        let
          aiocmd = buildPythonPackage rec {
            pname = "aiocmd";
            version = "0.1.5";
            propagatedBuildInputs = [ prompt-toolkit ];
            src = fetchPypi {
              inherit pname version;
              hash = "sha256-rCz3+N+NpFRi9qD4bpQ6RCeZdSnVvs98IOotODXwTOA=";
            };
          };
          psutil = buildPythonPackage rec {
            pname = "psutil";
            version = "6.1.0";
            src = fetchPypi {
              inherit pname version;
              hash = "sha256-NTgV9Zp/ZM2socAwfuE1WKBRL22wZOkv6DN4TwhTnHo=";
            };
          };
        in buildPythonPackage rec {
          pname = "openfreebuds";
          version = "0.17.0";
          format = "pyproject";
          nativeBuildInputs = [ pdm-backend ];
          propagatedBuildInputs = [ aiocmd aiohttp packaging pillow psutil qasync pynput dbus-next ];
          src = pkgs.fetchFromGitHub {
            owner = "melianmiko";
            repo = pname;
            rev = "v${version}";
            sha256 = "sha256-1NfcF1MoBXb+PPNJx993fzQNcGOZAZwf9QxzTvZcbxw=";
          };
        };
    })
  ];
}
