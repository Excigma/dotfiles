{ pkgs, self, ... }: {
  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };

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
    })
  ];
}
