{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      cloudflared = (prev.cloudflared.override {
        buildGoModule = pkgs.buildGoModule.override {
          go = pkgs.buildPackages.go_1_23.overrideAttrs (prevAttrs: {
            pname = "cloudflare-go";
            version = "1.22.5-devel-cf";

            src = pkgs.fetchFromGitHub {
              owner = "cloudflare";
              repo = "go";
              rev = "af19da5605ca11f85776ef7af3384a02a315a52b";
              hash = "sha256-6VT9CxlHkja+mdO1DeFoOTq7gjb3T5jcf2uf9TB/CkU=";
            };

            patches = map (patch:
              if (baseNameOf patch == "go_no_vendor_checks-1.23.patch") then
                ./patches/cloudflare-go-no-vendor-1.22.patch
              else
                patch) prevAttrs.patches;
          });
        };
      }).overrideAttrs { meta.broken = false; };

      marble-shell-theme = prev.marble-shell-theme.overrideAttrs (prevAttrs: {
        patches =
          [ ./patches/marble-disable-taskbar-icon-background.patch ./patches/marble-fix-quick-settings-padding.patch ]
          ++ (prevAttrs.patches or [ ]);
      });

      nautilus-python = prev.nautilus-python.overrideAttrs
        (prevAttrs: { patches = [ ./patches/nautilus-python-single-path.patch ] ++ (prevAttrs.patches or [ ]); });

      power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (prevAttrs: {
        # Disable tests, as they take a long time to run.
        mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [ "-Dtests=false" ];
        patches = [ ./patches/ppd-use-cool-platform-profile.patch ] ++ (prevAttrs.patches or [ ]);
      });

      sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (prevAttrs: {
        postInstall = (prevAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/screen-capture.oga";
      });
    })
  ];
}
