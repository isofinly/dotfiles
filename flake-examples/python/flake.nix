{
  description = "Python development environment with uv";

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
            python3
            uv
            ruff
            
            git
            jq
            curl
            
            # Required for building Python packages with native extensions
            gcc
            zlib
          ];

          shellHook = ''
            echo ""
            echo "Tools:"
            echo "  Python: $(python --version)"
            echo "  uv:     $(uv --version)"
            echo "  Ruff:   $(ruff --version)"
            echo ""

            # Create and activate virtual environment with uv
            export VIRTUAL_ENV=".venv"
            if [ ! -d "$VIRTUAL_ENV" ]; then
              echo "Creating virtual environment with uv..."
              uv venv "$VIRTUAL_ENV"
            fi
            
            source "$VIRTUAL_ENV/bin/activate"
            export PYTHONPATH="$PWD:$PYTHONPATH"

            # Configure library paths for packages with native extensions
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc
              pkgs.zlib
            ]}:$LD_LIBRARY_PATH"

            echo "Virtual environment activated at $VIRTUAL_ENV"
            echo "Use 'uv pip install <package>' or 'uv sync' to manage dependencies"
            echo ""
          '';
        };
      }
    );
}

