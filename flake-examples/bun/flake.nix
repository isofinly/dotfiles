{
  description = "Bun development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            bun
            
            git
            jq
            curl
          ];

          shellHook = ''
            echo ""
            echo "Tools:"
            echo "  Node.js: $(node --version)"
            echo "  Bun:     $(bun --version)"
            echo ""

            # NPM global packages location (avoids sudo)
            export NPM_CONFIG_PREFIX="$HOME/.npm-global"
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
            mkdir -p "$NPM_CONFIG_PREFIX"

            # Bun global packages
            export BUN_INSTALL="$HOME/.bun"
            export PATH="$BUN_INSTALL/bin:$PATH"
          '';
        };
      }
    );
}

