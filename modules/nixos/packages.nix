# modules/nixos/packages.nix
{ config, pkgs, ... }:
let
  sharedPackages = import ../shared/packages.nix { inherit pkgs; };
in
{
  environment.systemPackages =
    sharedPackages
    ++ (with pkgs; [
      ghostty
      neovim
      fastfetch
      ripgrep
      python314  # see note below
    ]);
}

