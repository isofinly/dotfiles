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

  # (buildGoModule.override { go = go_1_26; } {
  #  pname = "entire";
  #  version = "0.4.9";

  #   src = fetchgit {
  #     url = "https://github.com/entireio/cli";
  #     rev = "v0.4.9";
  #     hash = "sha256-DPSRgZdRgs4Sc9YF+BYWu2g12tyw/WmESaXCT5anA70=";
  #   };

  #   subPackages = [ "cmd/entire" ];
  #   vendorHash = "sha256-r8+mXHN0OwhO4D/DdZIKWOYaszflmrrjIZVj20Am9gw=";

  #   ldflags = [
  #     "-X main.version=v0.4.9"
  #     "-X main.commit=14b1c4407d7d92fb0f655d88356385a084e4a129" 
  #   ];
  # })
]
