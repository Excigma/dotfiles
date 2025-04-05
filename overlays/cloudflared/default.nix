{ prev, pkgs, ... }:
(prev.cloudflared.override {
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

      patches =
        map (patch: if (baseNameOf patch == "go_no_vendor_checks-1.23.patch") then ./go-no-vendor-1.22.patch else patch)
        old.patches;
    });
  };
}).overrideAttrs { meta.broken = false; }
