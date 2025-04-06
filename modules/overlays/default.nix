{ self, ... }:
let
  inherit (builtins) filter attrNames readDir;
in
{
  imports = map (file: "${./.}/${file}") (
    filter (x: x != "default.nix" && builtins.match ".*.nix" x != null) (attrNames (readDir ./.))
  );

  nixpkgs.overlays = with self.inputs; [
    nur.overlays.default

    (final: prev: {
      unstable = import nixpkgs-unstable { inherit (prev) config system; };
      stable = import nixpkgs-stable { inherit (prev) config system; };
    })
  ];
}
