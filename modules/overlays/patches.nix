{ pkgs, self, ... }: {
  nixpkgs.overlays = with self.inputs;
    [
      (final: prev: {
        unstable = import nixpkgs-unstable { inherit (prev) config system; };
        stable = import nixpkgs-stable { inherit (prev) config system; };

        cloudflared = (prev.cloudflared.override {
          buildGoModule = pkgs.buildGoModule.override {
            go = pkgs.buildPackages.go_1_23.overrideAttrs (old: {
              pname = "cloudflare-go";
              version = "1.22.5-devel-cf";

              src = pkgs.fetchFromGitHub {
                owner = "cloudflare";
                repo = "go";
                rev = "af19da5605ca11f85776ef7af3384a02a315a52b";
                hash = "sha256-6VT9CxlHkja+mdO1DeFoOTq7gjb3T5jcf2uf9TB/CkU=";
              };

              patches = map (patch:
                if (baseNameOf patch == "go_no_vendor_checks-1.23.patch") then ./go-no-vendor-1.22.patch else patch)
                old.patches;
            });
          };
        }).overrideAttrs { meta.broken = false; };

        sound-theme-freedesktop = prev.sound-theme-freedesktop.overrideAttrs (oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + "rm -f $out/share/sounds/freedesktop/stereo/screen-capture.oga";
        });

        marble-shell-theme = prev.marble-shell-theme.overrideAttrs (oldAttrs: {
          patches = [
            (builtins.toFile "disable-taskbar-icon-background" ''
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
            '')

            (builtins.toFile "fix-quick-settings-padding" ''
              diff --git a/theme/gnome-shell/.css/quick-settings.css b/theme/gnome-shell/.css/quick-settings.css
              index fcf8f86..e5f5c42 100644
              --- a/theme/gnome-shell/.css/quick-settings.css
              +++ b/theme/gnome-shell/.css/quick-settings.css
              @@ -2,7 +2,7 @@

               /* QS section */
               .quick-settings {
              -	padding: 15px;
              +	padding: 15px !important;
               	border-radius: 24px;
               }
            '')
          ];
        });

        nautilus-python = prev.nautilus-python.overrideAttrs (old: {
          patches = [
            (builtins.toFile "single-path" ''
              diff --git a/src/nautilus-python.c b/src/nautilus-python.c
              index 6e230ba..291640f 100644
              --- a/src/nautilus-python.c
              +++ b/src/nautilus-python.c
              @@ -229,18 +229,8 @@ nautilus_python_check_all_directories(GTypeModule *module) {
                   dirs = g_list_append(dirs, g_strdup (prefix_extension_dir));
               
                   // Check all system data dirs 
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

        power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (old: {
          # Disable tests, and they take a long time to run.
          mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dtests=false" ];
          patches = [
            (builtins.toFile "use-cool-platform-profile" ''
              diff --git a/src/ppd-driver-platform-profile.c b/src/ppd-driver-platform-profile.c
              index 28fc335..706ab82 100644
              --- a/src/ppd-driver-platform-profile.c
              +++ b/src/ppd-driver-platform-profile.c
              @@ -66,7 +66,7 @@ profile_to_acpi_platform_profile_value (PpdDriverPlatformProfile *self,
                     return "low-power";
                   return "quiet";
                 case PPD_PROFILE_BALANCED:
              -    return "balanced";
              +    return "cool";
                 case PPD_PROFILE_PERFORMANCE:
                   return "performance";
                 }
              --
              2.48.1
            '')
          ] ++ old.patches or [ ];
        });
      })
    ];
}
