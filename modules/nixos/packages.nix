# modules/nixos/packages.nix
{ config, pkgs, ... }:
let
  sharedPackages = import ../shared/packages.nix { inherit pkgs; };
in
{
  environment.systemPackages =
    sharedPackages
    ++ (with pkgs; [
      docker
      neovim
      vlc
      fastfetch
      ripgrep
      python314  # see note below
    ]);
}

