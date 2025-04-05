{ prev, ... }:
prev.sound-theme-freedesktop.overrideAttrs (oldAttrs: {
  postInstall = (oldAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/screen-capture.oga";
})
