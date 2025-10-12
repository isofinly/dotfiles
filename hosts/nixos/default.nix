{ config, pkgs, ... }:

{
  # Delegate actual system configuration to the modular NixOS files
  # Ensure modules/nixos/default.nix imports:
  #   - ./hardware-configuration.nix (copied from /etc/nixos)
  #   - ./packages.nix (module setting environment.systemPackages)
  #   - ./home-manager.nix (user HM config), if using HM now
  imports = [
    ../../modules/nixos/default.nix
  ];
}

