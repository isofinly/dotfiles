{
  description = "Starter Configuration for MacOS and NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager, following nixpkgs for consistency
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS (optional; kept from template)
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew on macOS (optional; kept from template)
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # Disko (optional; kept from template)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, disko, ... }@inputs:
  let
    user = "isofinly";

    linuxSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    darwinSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

    devShell = system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = with pkgs; mkShell {
          nativeBuildInputs = [
            bashInteractive
            git
          ];
          shellHook = ''
            export EDITOR=nvim
          '';
        };
      };

    mkApp = scriptName: system: {
      type = "app";
      program = "${
        (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')
      }/bin/${scriptName}";
    };

    mkLinuxApps = system: {
      "apply" = mkApp "apply" system;
      "build-switch" = mkApp "build-switch" system;
      "clean" = mkApp "clean" system;
      # The following are defined only if the files exist in apps/${system}/
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "install" = mkApp "install" system;
    };

    mkDarwinApps = system: {
      "apply" = mkApp "apply" system;
      "build" = mkApp "build" system;
      "build-switch" = mkApp "build-switch" system;
      "clean" = mkApp "clean" system;
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "rollback" = mkApp "rollback" system;
    };
  in
  {
    devShells = forAllSystems devShell;

    apps =
      nixpkgs.lib.genAttrs linuxSystems mkLinuxApps
      // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

    darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
      let
        user = "isofinly";
      in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              inherit user;
              enable = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = false;
              autoMigrate = true;
            };
          }
          ./hosts/darwin
        ];
      }
    );

    nixosConfigurations =
      # Platform-based default hosts using the shared host tree
      nixpkgs.lib.genAttrs linuxSystems (system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // { inherit user; };
          modules = [
            # Enable Home Manager as a NixOS module
            home-manager.nixosModules.home-manager

            # Import the host tree (which imports modules/nixos/*)
            ./hosts/nixos
          ];
        }
      )
      //
      # Additional explicitly named host example
      {
        hostname = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs // { inherit user; };
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/nixos/hostname
          ];
        };
      };
  };
}

