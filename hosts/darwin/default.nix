{ pkgs, ... }:

let
  user = "isofinly";
in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];

  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 14d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Required for nix-darwin
  system.stateVersion = 6;
  system.primaryUser = "${user}";

}
