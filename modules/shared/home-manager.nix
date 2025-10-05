{
  config,
  pkgs,
  lib,
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

  # Bash configuration as fallback
  bash = {
    enable = true;
    enableCompletion = true;
  };

  # Starship prompt
  starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Git configuration using imported settings
  git = {
    enable = true;
    userName = name;
    userEmail = email;
    lfs.enable = true;

    ignores = [
      "*.swp"
      ".DS_Store"
      "*.log"
      ".env"
    ];

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
        excludesfile = "~/.gitignore_global";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      http.postBuffer = 524288000;

      # Aliases from imported gitconfig
      alias = {
        mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
      };
    };
  };

  # Modern terminal utilities
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

  # Neovim configuration
  neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # SSH configuration
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

  programs.zsh = {
    enable = true;
    shellAliases = {
      cd = "z";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      grep = "grep --color=auto";
      g = "g++-12";
      py = "python3";
      l = "eza -lh --icons=auto";
      ls = "eza -1 --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "eza -lhD --icons=auto";
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

    autosuggestion.enable = true;
    enableCompletion = true;

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

    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
        };
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-K5wIspJfFp/t8xzI4QfqfuqDhQkW7YvFX8gJxTXh0Qw=";
        };
      }
    ];
  };
}
