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
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };

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
        config,
        lib,
        ...
      }:
      lib.mkMerge [
        (import ../shared/home-manager.nix { inherit config pkgs lib; })

        # Darwin-specific additions
        {
          home = {
            enableNixpkgsReleaseCheck = false;
            packages = pkgs.callPackage ./packages.nix { };
            file = lib.mkMerge [
              sharedFiles
              additionalFiles
            ];
            stateVersion = "23.11";

            # Darwin-specific PATH additions
            sessionPath = [
              "/Library/TeX/texbin"
              "$HOME/context/tex/texmf-osx-arm64/bin"
            ];
          };

          # Extend ZSH configuration with Darwin-specific init
          programs.zsh.initExtra = lib.mkAfter ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
          '';

          manual.manpages.enable = false;
        }
      ];
  };
}
