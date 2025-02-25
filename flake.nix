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

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
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
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix

            (if builtins.pathExists ./secrets/default.nix then
              ./secrets
            else
              pkgs.lib.warn "excigma: no secrets found!" { })

            {
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
                users.excigma = import ./home.nix;
              };
              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
          ];
        };
      };

      homeConfigurations."excigma@latitude-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit config system; };
        modules = [ ./home.nix ];
      };
    };
}
