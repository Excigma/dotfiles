{ pkgs, self, ... }: {
  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };

      sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/camera-shutter.oga";
      });

      go-10mb-video = pkgs.buildGoModule {
        pname = "10mb.video";
        version = "14e8aaac56189d48418d157171bae10f2ea9defd";

        src = pkgs.fetchFromGitHub {
          owner = "ugjka";
          repo = "10mb.video";
          rev = "14e8aaac56189d48418d157171bae10f2ea9defd";
          sha256 = "sha256-mcpQ6AVAXJjNbClUF6pgZbU47KCn4viaA6fB7eF7CZg";
        };

        vendorHash = null;
        subPackages = [ "." ];
        buildInputs = with pkgs; [ ffmpeg fdk-aac-encoder ];

        patches = [
          (builtins.toFile "single-path" ''
            diff --git a/main.go b/main.go
            index dc8d412..0c06e72 100644
            --- a/main.go
            +++ b/main.go
            @@ -21,6 +21,7 @@ import (
             	"os/exec"
             	"os/signal"
             	"path"
            +	"path/filepath"
             	"strconv"
             	"strings"
             	"syscall"
            @@ -228,10 +229,10 @@ func main() {
             		vbitrate = int(bitfloat)
             	}
             
            -	// construct output filename
            -	arr := strings.Split(file, ".")
            -	output := strings.Join(arr[0:len(arr)-1], ".")
            -	output = fmt.Sprintf("%gmb.%s.mp4", *size, output)
            +	// construct output filename next to the input file
            +	base := filepath.Base(file)
            +	name := strings.TrimSuffix(base, filepath.Ext(base))
            +	output := filepath.Join(filepath.Dir(file), fmt.Sprintf("%gmb.%s.mp4", *size, name))
             
             	// beware: changing this changes the muxing overhead
             	const FPS = 24
            -- 
            2.47.2
          '')
        ];

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
