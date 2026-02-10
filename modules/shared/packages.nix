{ pkgs }:

with pkgs;
[
  # Core system utilities
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
  hack-font
  jetbrains-mono
  noto-fonts
  noto-fonts-color-emoji
  dejavu_fonts
  font-awesome

  # Build essentials (generic)
  gnumake
  pkg-config
  libtool

  # LSP
  nil
  nixd

  # Other
  obsidian
  darktable

  # opencode
  # codex
]
