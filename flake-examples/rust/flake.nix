{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        protoTools = with pkgs; [
          buf
          protobuf
          protoc-gen-rust
          protoc-gen-rust-grpc
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              (rust-bin.stable.latest.default.override {
                extensions = [
                  "rust-src"
                  "rust-analyzer"
                ];
              })
              openssl
              pkg-config
              cargo-deny
            ]
            ++ protoTools;

          env = {
            OUT_DIR = "~/.cargo-target/proto";
          };

          shellHook = ''
            rustc --version
            buf --version
          '';
        };
      }
    );
}

