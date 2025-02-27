{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      user = "excigma";
      config.allowUnfree = true;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit config system; };
      specialArgs = { inherit self user; };
    in {
      formatter.${system} = pkgs.nixfmt-classic;
      # Exposes repl accessible with `nix develop`
      devShells.${system} = with pkgs; rec {
        default = repl;
        repl = mkShellNoCC {
          shellHook = ''
            exec nix repl --expr "let
            	flake = builtins.getFlake \"\''${builtins.getEnv \"PWD\"}?submodules=1\";
            in flake
            	// flake.nixosConfigurations.default
            	// flake.nixosConfigurations.default.config.home-manager.users"
          '';
        };
      };
      nixosConfigurations = rec {
        default = latitude-nixos;
        latitude-nixos = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./modules/nixos
            home-manager.nixosModules.home-manager

            (if builtins.pathExists ./secrets/default.nix then
              ./secrets
            else
              pkgs.lib.warn "${user}: no secrets found!" { })

            {
              nix = {
                gc = {
                  automatic = true;
                  options = "--delete-older-than 30d";
                };
                optimise.automatic = true;
                registry.pkgs.flake = self;
                settings = {
                  auto-optimise-store = true;
                  experimental-features = [ "nix-command" "flakes" ];
                  nix-path = "nixpkgs=/etc/nix/inputs/nixpkgs";
                  trusted-users = [ user ];
                };
              };
              nixpkgs = {
                inherit config;
                hostPlatform = system;
              };
              home-manager = {
                extraSpecialArgs = specialArgs;
                useGlobalPkgs = true;
                users.${user} = import ./modules/hm/default.nix;
                useUserPackages = true;
              };
            }
          ];
        };
      };

      homeConfigurations."${user}@latitude-nixos" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = specialArgs;
        modules = [ ./modules/hm/default.nix ];
        inherit pkgs;
      };
    };
}
