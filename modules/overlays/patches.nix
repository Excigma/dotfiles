{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      marble-shell-theme = prev.marble-shell-theme.overrideAttrs (prevAttrs: {
        patches = [
          ./patches/marble-disable-taskbar-icon-background.patch
          ./patches/marble-fix-quick-settings-padding.patch
        ] ++ (prevAttrs.patches or [ ]);
      });

      nautilus-python = prev.nautilus-python.overrideAttrs (prevAttrs: {
        patches = [ ./patches/nautilus-python-single-path.patch ] ++ (prevAttrs.patches or [ ]);
      });

      power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (prevAttrs: {
        # Disable tests, as they take a long time to run.
        mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [ "-Dtests=false" ];
        patches = [ ./patches/ppd-use-cool-platform-profile.patch ] ++ (prevAttrs.patches or [ ]);
      });

      rnote = prev.rnote.overrideAttrs (prevAttrs: {
        patches = [ ./patches/rnote-move-pen-picker-to-top.patch ] ++ (prevAttrs.patches or [ ]);
      });

      sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (prevAttrs: {
        postInstall =
          (prevAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/screen-capture.oga";
      });
    })
  ];
}
