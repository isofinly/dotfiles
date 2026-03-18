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

        scanTools = with pkgs; [
          masscan
          nmap
          libpcap
          tcpdump
        ];

        llvmToolchain = with pkgs; [
          clang
          lld
          llvm
        ];

        notifyTools = with pkgs; [
          curl
          openssl
        ];

        persistenceTools = with pkgs; [
          sqlite
          rocksdb
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
              pkg-config
              cargo-deny
            ]
            ++ protoTools
            ++ scanTools
            ++ llvmToolchain
            ++ notifyTools
            ++ persistenceTools;

          env = {
            OUT_DIR = "~/.cargo-target/proto";
            CC = "${pkgs.clang}/bin/clang";
            CXX = "${pkgs.clang}/bin/clang++";
            RUSTFLAGS = "-Clinker-plugin-lto -Clinker=clang -Clink-arg=-fuse-ld=lld";
            LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
          };

          shellHook = ''
            rust_llvm_major=$(rustc -vV | sed -n 's/^LLVM version: \([0-9][0-9]*\)\..*/\1/p')
            clang_llvm_major=$(clang --version | sed -n 's/.*version \([0-9][0-9]*\)\..*/\1/p' | head -n 1)

            if [ -n "$rust_llvm_major" ] && [ -n "$clang_llvm_major" ] && [ "$rust_llvm_major" != "$clang_llvm_major" ]; then
              echo "error: clang LLVM major ($clang_llvm_major) does not match rustc LLVM major ($rust_llvm_major)"
              return 1
            fi

            rustc --version
            buf --version
            clang --version | head -n 1
            ld.lld --version | head -n 1
            masscan --version || true
            nmap --version | head -n 1
            sqlite3 --version
            rocksdb_dump --version || true
            curl --version | head -n 1
          '';
        };
      }
    );
}
