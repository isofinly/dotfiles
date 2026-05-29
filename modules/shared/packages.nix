{ pkgs }:
let
  crush = pkgs.buildGo126Module {
    pname = "crush";
    version = "0.71.0";

    src = pkgs.fetchFromGitHub {
      owner = "charmbracelet";
      repo = "crush";
      rev = "dd4318a";
      hash = "sha256-X+bCwpyAFUkM1ljj5I6w6gts6b6IWYm1d4veV0mR0gA=";
    };

    vendorHash = "sha256-moVpfFscZLz7mQw+pqaG132k9KTNyRdKOFNNd0RN1oo=";

    doCheck = false;
  };
in
with pkgs;
[
  # Core system utilities
  coreutils
  findutils
  gnused
  gnugrep
  gawk
  nmap
  killall
  
  # Build essentials (generic)

  bento4
  gpac
  ffmpeg
  zlib

  gnumake
  pkg-config
  libtool


  # Shell and terminal utilities
  zsh
  bash
  wget
  curl
  bash-completion
  starship
  zoxide
  eza
  ripgrep
  fzf
  atuin
  tmux

  scc
  tree
  jq
  yq

  # Version control tools
  jujutsu  
  git
  gh

  p7zip
  unrar
  zip
  unzip

  # Fonts
  meslo-lgs-nf
  jetbrains-mono
  font-awesome
  shellcheck

  # LSP
  nil
  nixd
  tree-sitter

  # Other
  # darktable

  # Agents
  opencode
  crush

  flyctl

  deno

  tailscale

  yt-dlp
]
