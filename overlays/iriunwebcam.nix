{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
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
}
