{ ... }:

{
  ".profile" = {
    text = builtins.readFile ../shared/config/profile;
  };

  ".zprofile" = {
    text = builtins.readFile ../shared/config/zprofile;
  };

  # Git configuration
  ".gitconfig" = {
    text = builtins.readFile ../shared/config/gitconfig;
  };

  ".gitignore_global" = {
    text = builtins.readFile ../shared/config/gitignore_global;
  };

  # Starship prompt configuration
  ".config/starship.toml" = {
    text = builtins.readFile ../shared/config/starship.toml;
  };

  ".config/wezterm" = {
    source = ../shared/config/wezterm;
    recursive = true;
  };

  ".config/ghostty" = {
    source = ../shared/config/ghostty;
    recursive = true;
  };

  # Editor configurations
  ".config/nvim" = {
    source = ../shared/config/nvim;
    recursive = true;
  };

  ".config/zed" = {
    source = ../shared/config/zed;
    recursive = true;
  };

  # Shell utilities
  ".config/atuin" = {
    source = ../shared/config/atuin;
    recursive = true;
  };

  # Development tools
  ".config/git-cliff" = {
    source = ../shared/config/git-cliff;
    recursive = true;
  };
}
