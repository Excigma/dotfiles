{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      determinate,
      nix-index-database,
      home-manager,
      ...
    }:
    let
      user = "excigma";
      config.allowUnfree = true;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit config system; };
      specialArgs = { inherit self user; };
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
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
            ./modules/overlays

            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            nix-index-database.nixosModules.nix-index

            (
              if builtins.pathExists ./secrets/default.nix then
                ./secrets
              else
                pkgs.lib.warn "${user}: no secrets found!" { }
            )

            {
              nix = {
                gc = {
                  automatic = true;
                  options = "--delete-older-than 30d";
                };
                optimise.automatic = true;
                registry.pkgs.flake = self;
                settings = {
                  eval-cores = 0;
                  auto-optimise-store = true;
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
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
                users.${user} = import ./modules/home-manager/default.nix;
                useUserPackages = true;
              };
            }
          ];
        };
      };

      homeConfigurations."${user}@latitude-nixos" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = specialArgs;
        modules = [ ./modules/home-manager/default.nix ];
        inherit pkgs;
      };
    };
}
