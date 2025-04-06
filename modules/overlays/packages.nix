{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
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
        buildInputs = with pkgs; [
          ffmpeg
          fdk-aac-encoder
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
        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          dpkg
          qt5.wrapQtAppsHook
        ];
        buildInputs = with pkgs; [
          alsa-lib
          avahi
          libdrm
          libgcc
          libusbmuxd
          libsForQt5.qt5.qtbase
        ];
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

      openfreebuds =
        with pkgs.python3Packages;
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
        in
        buildPythonPackage rec {
          pname = "openfreebuds";
          version = "0.17.0";
          format = "pyproject";
          nativeBuildInputs = [
            pkgs.pdm
            pkgs.just
            pyqt6
            pkgs.qt6.qttools
            pkgs.qt6.wrapQtAppsHook
            pdm-backend
          ];
          propagatedBuildInputs = [
            aiocmd
            aiohttp
            packaging
            pillow
            psutil
            qasync
            pyqt6
            pynput
            dbus-next
          ];
          configurePhase = ''pyuic6 ./openfreebuds_qt/designer/'';
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
