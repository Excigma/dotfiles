{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-oldstable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-index-database,
      home-manager,
      ...
    }:
    let
      user = "excigma";
      config.allowUnfree = true;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit config system; };
      specialArgs = {
        inherit
          self
          user
          home-manager
          nix-index-database
          ;
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;
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

        # Dell Latitude Daily Driver
        latitude-nixos = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/latitude
            ./modules/overlays
          ];
        };

        # Fujitsu Desktop (Akl)
        akl-fujitsu-nixos = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/akl-fujitsu-nixos
            ./modules/overlays
          ];
        };

        # Orange Pi Zero 2W (Akl)
        akl-opi-zero-2w = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/akl-opi-zero-2w
            ./modules/overlays
          ];
        };

        # Sydney ARM Server
        syd-arm = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/syd-arm
            ./modules/overlays
          ];
        };

        # Sydney AMD Server
        syd-amd = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/syd-amd
            ./modules/overlays
          ];
        };
      };

      homeConfigurations = {
        "${user}@latitude-nixos" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          modules = [ ./profiles/home-manager/daily-driver.nix ];
          inherit pkgs;
        };

        "${user}@akl-fujitsu-nixos" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          modules = [ ./profiles/home-manager/desktop.nix ];
          inherit pkgs;
        };

        "${user}@akl-opi-zero-2w" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          modules = [ ./profiles/home-manager/base.nix ];
          pkgs = import nixpkgs {
            inherit config;
            system = "aarch64-linux";
          };
        };

        "${user}@syd-arm" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          modules = [ ./profiles/home-manager/base.nix ];
          pkgs = import nixpkgs {
            inherit config;
            system = "aarch64-linux";
          };
        };

        "${user}@syd-amd" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          modules = [ ./profiles/home-manager/base.nix ];
          inherit pkgs;
        };
      };
    };
}
