{
  config,
  pkgs,
  ...
}:

let
  user = "isofinly";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
    ./system.nix
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    
    casks = pkgs.callPackage ./casks.nix { };
    brews = pkgs.callPackage ./brews.nix { };

    masApps = {
      "telegram" = 747648890;
      "Tailscale" = 1475387142;
      "V2Box - V2ray Client" = 6446814690;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} =
      {
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          ../shared/home-manager.nix
        ];

        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            sharedFiles
            additionalFiles
          ];
          stateVersion = "25.05";

          # Darwin-specific PATH additions
          sessionPath = [
            "/Library/TeX/texbin"
            "$HOME/context/tex/texmf-osx-arm64/bin"
          ];
        };

        # Darwin-specific ZSH extension
        programs.zsh.initContent = lib.mkAfter ''
          # Key bindings
          bindkey '^[b' backward-word
          bindkey '^[f' forward-word
          bindkey '^[^?' backward-kill-word
          bindkey "^A" beginning-of-line
          bindkey "^E" end-of-line
          bindkey "^[[3;9~" kill-whole-line
          bindkey "^[[3~" delete-char

          eval "$(/opt/homebrew/bin/brew shellenv)"
        '';

        manual.manpages.enable = false;
      };
  };
}
