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
        version = "2.8.5";
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
          (libusbmuxd.overrideAttrs (oldAttrs: {
            version = "2.0.2";

            src = fetchFromGitHub {
              owner = "libimobiledevice";
              repo = "libusbmuxd";
              rev = "2.0.2";
              hash = "sha256-yd1pihlu1Kpk6J3kC3oF7UGQcWzgGhw8NZPNHq3+N40=";
            };
          }))
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
          hash = "sha256-K9GItagaHVkMBV1Y3HsYD08yIf6lJZDi6GSLEQQo2pQ=";
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
          configurePhase = "pyuic6 ./openfreebuds_qt/designer/";
          dontWrapQtApps = true;
          dontWrapPythonPrograms = true;
          postFixup = ''
            sed -i "s:#!.*:#!${pkgs.lib.getExe pkgs.python3Full}\nprint(\"Using python39Full interpreter!\"):" $out/bin/openfreebuds_cmd
            sed -i "s:#!.*:#!${pkgs.lib.getExe pkgs.python3Full}\nprint(\"Using python39Full interpreter!\"):" $out/bin/openfreebuds_qt
            wrapPythonPrograms
            wrapQtApp $out/bin/openfreebuds_qt
          '';
          src = pkgs.fetchFromGitHub {
            owner = "melianmiko";
            repo = pname;
            rev = "v${version}";
            sha256 = "sha256-1NfcF1MoBXb+PPNJx993fzQNcGOZAZwf9QxzTvZcbxw=";
          };
        };

      semantra = pkgs.python3Packages.buildPythonPackage {
        pname = "semantra";
        version = "0.1.12";
        format = "pyproject";

        src = pkgs.fetchFromGitHub {
          owner = "freedmand";
          repo = "semantra";
          rev = "1aed8fd0057f6b3eb7946e0f351f9c668842774d";
          sha256 = "sha256-vz7P++DqxXlSuLH75lPXs+CYeGq+rbDE2Eeh1XozZDQ=";
        };

        nativeBuildInputs = with pkgs.python3Packages; [
          setuptools
          wheel
        ];

        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace 'annoy_fixed>=1.16.3' 'annoy>=1.16.3'
          substituteInPlace pyproject.toml \
            --replace 'numpy<2' 'numpy'
            
        '';

        propagatedBuildInputs = with pkgs.python3Packages; [
          annoy
          click
          flask
          openai
          pillow
          pypdfium2
          python-dotenv
          numpy
          tiktoken
          torch
          tqdm
          transformers
        ];

        meta = with pkgs.lib; {
          description = "A semantic search CLI tool";
          homepage = "https://github.com/freedmand/semantra";
          license = licenses.mit;
        };
      };

      # https://github.com/ulissesf/qmassa
      # use cargo to build
      # The minimum requirements to compile & run qmassa are:

      # Compile-time: Rust v1.74 or later, pkg-config and libudev development packages
      # Runtime: Linux kernel v6.8 or later to report most usage stats
      qmassa = pkgs.rustPlatform.buildRustPackage rec {
        pname = "qmassa";
        version = "0.7.0";

        src = pkgs.fetchFromGitHub {
          owner = "ulissesf";
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-k+oix860KwDIGBr1qaOvabkWdTQLrKRDXXFiW2qWx5I=";
        };

        nativeBuildInputs = with pkgs; [
          pkg-config
        ];
        buildInputs = with pkgs; [
          systemd
        ];

        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit pname version src;
          hash = "sha256-AQAgNRkb0qTeA99uv95rg837INVC36iRgR7xyk7vlzo=";
        };

        meta = with pkgs.lib; {
          description = "A command-line tool to monitor CPU and GPU usage";
          homepage = "https://github.com/ulissesf/qmassa";
          license = licenses.mit;
        };
      };
      
      # https://github.com/jb2170/better-adb-sync
      better-adb-sync = pkgs.python3Packages.buildPythonApplication rec {
        pname = "better-adb-sync";
        version = "1.4.0"; # Please check for the latest version on PyPI
        format = "pyproject"; # Specify that it uses pyproject.toml

        src = pkgs.fetchPypi {
          inherit version;
          pname = "BetterADBSync"; # PyPI name might be case-sensitive
          sha256 = "sha256-z6E8gayItFEpT9GIi7LAZ5xIptNyUH/IBj6mJffmzoI=";
        };

        nativeBuildInputs = with pkgs.python3Packages; [
          setuptools # Use setuptools as the build backend
        ];

        propagatedBuildInputs = with pkgs.python3Packages; [
          adb-shell
          tqdm
          pkgs.android-tools # adb CLI tool
        ];

        meta = with pkgs.lib; {
          description = "A better adb-sync, based on adb-shell, with a progress bar";
          homepage = "https://github.com/jb2170/better-adb-sync";
          license = licenses.mit; # Check the actual license from the repo
          maintainers = [ ]; # Add your handle here
          platforms = platforms.linux; # Or platforms.all if applicable
          mainProgram = "better-adb-sync";
        };
      };
    })
  ];
}
