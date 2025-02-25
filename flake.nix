{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

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
          inherit system;
          specialArgs = { inherit user; };

          modules = [
            ./hardware-configuration.nix
            ./configuration.nix

            (if builtins.pathExists ./secrets/default.nix then
              ./secrets
            else
              pkgs.lib.warn "${user}: no secrets found!" { })

            {
              nix = {
                registry.pkgs.flake = self;
                optimise.automatic = true;
                settings = {
                  auto-optimise-store = true;
                  experimental-features = [ "nix-command" "flakes" ];
                  trusted-users = [ user ];
                  nix-path = "nixpkgs=/etc/nix/inputs/nixpkgs";
                };
                gc = {
                  automatic = true;
                  options = "--delete-older-than 30d";
                };
              };

              nixpkgs = {
                inherit config;
                hostPlatform = system;
                overlays = [ inputs.nur.overlays.default ];
              };
            }

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${user}" = import ./home.nix;
              };
              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
          ];
        };
      };

      homeConfigurations."${user}@latitude-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit config system; };
        modules = [ ./home.nix ];
      };
    };
}
