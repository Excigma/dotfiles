{ pkgs, self, ... }: {
  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };

      sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/camera-shutter.oga";
      });

      marble-shell-theme = let
        no-backgrounds = ''
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
        '';
      in prev.marble-shell-theme.overrideAttrs (oldAttrs: {
        version = "47.0";
        nativeBuildInputs = with pkgs; [ python3 dconf gnome-shell ];
        src = pkgs.fetchFromGitHub {
          owner = "imarkoff";
          repo = "Marble-shell-theme";
          rev = "1e83e073f7e50eaaf82763edbdae59585ca5e585";
          hash = "sha256-+uPjwOUwrdFfBvpWtuZhe789v2xvZG3XeFyYw8HP8QM=";
        };
        patchPhase = ''
          runHook prePatch
          substituteInPlace scripts/config.py --replace-fail "~/.themes" ".themes"
          patch -p1 << EOF
          ${no-backgrounds}
          EOF
          runHook postPatch
        '';
      });

      htop = prev.htop.overrideAttrs (oldAttrs: {
        patches = [
          (pkgs.fetchpatch {
            name = "1352.patch";
            url = "https://github.com/htop-dev/htop/pull/1352.patch";
            hash = "sha256-BoXKQPPJcKLDaZxwwtRgtsRHEU0XJ4lDRelIm30csts=";
          })
        ] ++ oldAttrs.patches or [ ];
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
            index 6e230ba..f5b51f1 100644
            --- a/src/nautilus-python.c
            +++ b/src/nautilus-python.c
            @@ -228,19 +228,8 @@ nautilus_python_check_all_directories(GTypeModule *module) {
                 gchar *prefix_extension_dir = DATADIR "/nautilus-python/extensions";
                 dirs = g_list_append(dirs, g_strdup (prefix_extension_dir));
             
            -    // Check all system data dirs 
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
    })
  ];
}
