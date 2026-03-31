{ pkgs }:

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

  # Other
  obsidian
  darktable

  # Agents
  opencode
]
