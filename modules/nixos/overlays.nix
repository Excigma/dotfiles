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
        version = "ccd13c04b0b6b630cb46c1230b4b714424e073d0";

        src = pkgs.fetchFromGitHub {
          owner = "ugjka";
          repo = "10mb.video";
          rev = "ccd13c04b0b6b630cb46c1230b4b714424e073d0";
          sha256 = "sha256-VIb1F3ovq/JD4h/reLdIogoq/LgnMg+guGoUv+CK/AQ=";
        };

        vendorHash = null;
        subPackages = [ "." ];
        buildInputs = with pkgs; [ ffmpeg fdk-aac-encoder ];

        patches = [
          (builtins.toFile "single-path" ''
            diff --git a/main.go b/main.go
            index 6b5f33e..702b2e2 100644
            --- a/main.go
            +++ b/main.go
            @@ -79,17 +79,11 @@ func main() {
             		os.Exit(1)
             	}
             
            -	destdir, err := os.Getwd()
            -	if err != nil {
            -		fmt.Fprintln(os.Stderr, err)
            -		os.Exit(1)
            -	}
            -
             	filepath := flag.Args()[0]
             	file := path.Base(filepath)
             	dir := path.Dir(filepath)
             
            -	err = os.Chdir(dir)
            +	err := os.Chdir(dir)
             	if err != nil {
             		fmt.Fprintln(os.Stderr, err)
             		os.Exit(1)
            @@ -246,7 +240,7 @@ func main() {
             	// construct output filename
             	arr := strings.Split(file, ".")
             	output := strings.Join(arr[0:len(arr)-1], ".")
            -	output = fmt.Sprintf("%s/%gmb.%s.mp4", destdir, *size, output)
            +	output = fmt.Sprintf("%s/%gmb.%s.mp4", dir, *size, output)
             
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
