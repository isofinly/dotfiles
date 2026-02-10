{
  pkgs,
  lib,
  config,
  ...
}:

let
  name = "isofinly";
  user = "isofinly";
  email = "isofinly@icloud.com";
in
{
  # XDG Base Directory specification
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # Environment variables
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    HOMEBREW_NO_ENV_HINTS = "1";
    CARGO_TARGET_DIR = "$HOME/.cargo-target";
    OSFONTDIR = "/usr/local/share/fonts;$HOME/.fonts";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.duckdb/cli/latest"
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = true;

      dotDir = config.home.homeDirectory;

      shellAliases = {
        cd = "z";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        grep = "grep --color=auto";
        g = "g++-12";
        py = "python3";
        l = "eza -lh --icons=never --hyperlink";
        ls = "eza -1 --icons=never --hyperlink";
        ll = "eza -lha --icons=never --sort=name --group-directories-first --hyperlink";
        ld = "eza -lhD --icons=never --hyperlink";
        git-cliff = "git-cliff --config ~/.config/git-cliff/config.toml";
        gc = "g++ -std=c++17 -Wall -O3 -o";
        k = "kubectl";
        t = "tofu";
      };

      history = {
        size = 1000;
        save = 1000;
        path = "${config.xdg.cacheHome}/zsh/history";
        ignoreDups = true;
        ignoreAllDups = true;
      };

      setOptions = [
        "ALWAYS_TO_END"
        "AUTO_MENU"
        "AUTOCD"
        "COMPLETE_IN_WORD"
        "PROMPT_SUBST"
        "MENU_COMPLETE"
        "LIST_PACKED"
        "AUTO_LIST"
        "HIST_IGNORE_DUPS"
        "HIST_FIND_NO_DUPS"
      ];

      initContent = ''
        # Docker completions
        fpath=($HOME/.docker/completions $fpath)

        # Nix daemon
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    git = {
      enable = true;
      lfs.enable = true;

      ignores = [
        "*.swp"
        ".DS_Store"
        "*.log"
        ".env"
      ];

      settings = {
        user = {
          name = name;
          email = email;
        };
        init.defaultBranch = "main";
        core = {
          editor = "nvim";
          autocrlf = "input";
          excludesfile = "~/.gitignore_global";
        };
        pull.rebase = true;
        rebase.autoStash = true;
        http.postBuffer = 524288000;

        alias = {
          mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
        };
      };
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        update_check = false;
        sync_address = "";
        search_mode = "fuzzy";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [
        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/${user}/.ssh/config_external")
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/${user}/.ssh/config_external")
      ];
      matchBlocks = {
        "*" = {
          sendEnv = [
            "LANG"
            "LC_*"
          ];
          hashKnownHosts = true;
        };
      };
    };
  };
}
