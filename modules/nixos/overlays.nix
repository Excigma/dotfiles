args@{ self, pkgs, ... }:
let inherit (builtins) attrNames listToAttrs readDir replaceStrings;
in {
  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev:
      listToAttrs (map (file: {
        name = replaceStrings [ ".nix" ] [ "" ] file;
        value = pkgs.callPackage "${self}/overlays/${file}" (args // { inherit final prev; });
      }) (attrNames (readDir "${self}/overlays"))))

    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };
      stable = import nixpkgs-stable { inherit (prev) config system; };
    })
  ];
}
