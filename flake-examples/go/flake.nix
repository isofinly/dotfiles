{
  description = "Go and Protobuf development environment";

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

        protoTools = with pkgs; [
          buf
          protobuf
          protoc-gen-go
          protoc-gen-go-grpc
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              go
              sqlc
              gopls
              delve
              
              openssl
              pkg-config
              postgresql

              git
              jq
              curl
              gnumake
            ]
            ++ protoTools;

          shellHook = ''
            echo ""
            echo "Tools:"
            echo "  Go:      $(go version | cut -d' ' -f3)"
            echo "  protoc:  $(protoc --version)"
            echo "  sqlc:    $(sqlc version)"
            echo "  buf:     $(buf --version)"
            echo ""

            export GOPATH="$HOME/go"
            export PATH="$GOPATH/bin:$PATH"
            mkdir -p "$GOPATH/bin"

            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
            export OPENSSL_DIR="${pkgs.openssl.dev}"
            export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
            export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
          '';
        };
      }
    );
}

