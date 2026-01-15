{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.useGlobalPkgs = true;

  home-manager.users.isofinly =
    { pkgs, lib, ... }:
    {
      imports = [
        ../shared/home-manager.nix
      ];

      home.stateVersion = "26.05";

      # Use Zsh via Home Manager (manages ~/.zshrc, plugins, aliases, etc.)
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };

      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        # Optional tweaks:
        # flags = [ "--disable-up-arrow" ];
        # settings = { auto_sync = true; };  # see HM options
      };

      # Darwin-specific ZSH extension
      programs.zsh.initContent = lib.mkAfter ''
              setopt NO_BEEP
              zstyle ":completion:*" beep false
              setopt NO_LIST_BEEP
        # Use emacs keymap so the widget names below exist
        bindkey -e

        # Word motion with Meta (Alt)
        bindkey '^[b' backward-word
        bindkey '^[f' forward-word

        # Backward kill word with Meta+Backspace
        # Many Linux terminals send ESC-DEL (\e^?) or ESC-BS (\e^H); bind both
        bindkey '^[^?' backward-kill-word   # ESC 0x7f (DEL)
        bindkey '^[^H' backward-kill-word   # ESC ^H (BS)

        # Line start/end with Ctrl
        bindkey '^A' beginning-of-line
        bindkey '^E' end-of-line

        # Delete key (plain Delete)
        bindkey '^[[3~' delete-char

        # Alt+Delete on Linux typically sends ESC [ 3 ; 3 ~ (xterm/gnome-terminal)
        # Map that to kill the whole line
        bindkey '^[[3;3~' kill-whole-line

        # Optional: map Ctrl+Delete (often ESC [ 3 ; 5 ~) to kill forward word
        bindkey '^[[3;5~' kill-word

        # Optional: Alt+Arrow keys for word motion (common on Linux)
        bindkey '^[[1;3D' backward-word     # Alt+Left
        bindkey '^[[1;3C' forward-word      # Alt+Right
      '';

      # Optional: ensure interactive shells see Zsh as SHELL
      home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
    };
}
