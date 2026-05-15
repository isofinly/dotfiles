{ pkgs }:
let
  crush = pkgs.buildGo126Module {
    pname = "crush";
    version = "0.65.3";

    src = pkgs.fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "3aa26d9";
      hash = "sha256-X+bCwpyAFUkM1ljj5I6w6gts6b6IWYm1d4veV0mR0gA=";
    };

    vendorHash = "sha256-moVpfFscZLz7mQw+pqaG132k9KTNyRdKOFNNd0RN1oo=";

    doCheck = false;
  };
in
with pkgs;
[
  # Core system utilities
  tailscale
  coreutils
  findutils
  gnused
  gnugrep
  gawk
  killall
  wget
  curl
  zip
  unzip
  tree
  jq
  yq

  # Shell and terminal utilities
  zsh
  bash
  bash-completion
  starship
  zoxide
  eza
  ripgrep
  fzf
  atuin
  scc

  # Version control tools
  git
  git-cliff
  gh

  nmap

  p7zip
  unrar

  # Fonts
  meslo-lgs-nf
  jetbrains-mono
  font-awesome

  # Build essentials (generic)
  gnumake
  pkg-config
  libtool

  bento4
  gpac
  ffmpeg
  zlib

  shellcheck

  # LSP
  nil
  nixd
  tree-sitter

  # Other
  obsidian
  darktable

  # Agents
  opencode
  crush

  flyctl
]
