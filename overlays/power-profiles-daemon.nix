{ prev, ... }:
prev.power-profiles-daemon.overrideAttrs (old: {
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
})
