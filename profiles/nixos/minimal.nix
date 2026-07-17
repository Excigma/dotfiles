{
  pkgs,
  lib,
  user,
  self,
  home-manager,
  nix-index-database,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index
  ];

  time.timeZone = "Pacific/Auckland";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_NZ.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_NZ.UTF-8";
      LC_IDENTIFICATION = "en_NZ.UTF-8";
      LC_MEASUREMENT = "en_NZ.UTF-8";
      LC_MONETARY = "en_NZ.UTF-8";
      LC_NAME = "en_NZ.UTF-8";
      LC_NUMERIC = "en_NZ.UTF-8";
      LC_PAPER = "en_NZ.UTF-8";
      LC_TELEPHONE = "en_NZ.UTF-8";
      LC_TIME = "en_NZ.UTF-8";
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "wheel"
      "video"
      "input"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    registry.pkgs.flake = self;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix-path = "nixpkgs=/etc/nix/inputs/nixpkgs";
      trusted-users = [ user ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    nano
    gh
    nh
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = import ../home-manager/minimal.nix;
    extraSpecialArgs = { inherit self user; };
  };

  system.stateVersion = lib.mkDefault "24.11";
}
