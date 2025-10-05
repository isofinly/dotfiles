{
  pkgs,
  ...
}:

let
  user = "isofinly";
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"
  ];
in
{
  imports = [
    ../../modules/nixos/disk-config.nix
    ../../modules/shared
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    # Uncomment for AMD GPU
    # initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "uinput" ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "%HOST%"; # Define your hostname.
    useDHCP = false;
    interfaces."%INTERFACE%".useDHCP = true;
  };

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [
        "@admin"
        "${user}"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Manages keys and such
  programs = {
    gnupg.agent.enable = true;

    # Needed for anything GTK related
    dconf.enable = true;

    # My shell
    zsh.enable = true;
  };

  services = {
    # Fallback console on tty1: auto-login your user
    getty.autologinUser = user;
    getty.autologinOnce = false;

    # Display manager & X server
    displayManager.defaultSession = "none+bspwm";
    xserver = {
      enable = true;

      # Uncomment these for AMD or Nvidia GPU
      # boot.initrd.kernelModules = [ "amdgpu" ];
      # videoDrivers = [ "amdgpu" ];
      # videoDrivers = [ "nvidia" ];

      # Uncomment for Nvidia GPU
      # This helps fix tearing of windows for Nvidia cards
      # screenSection = ''
      #   Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      #   Option       "AllowIndirectGLXProtocol" "off"
      #   Option       "TripleBuffer" "on"
      # '';

      displayManager = {
        lightdm = {
          enable = true;
          greeters.slick.enable = true;
          background = ../../modules/nixos/config/login-wallpaper.png;
        };
      };

      # Tiling window manager
      windowManager.bspwm = {
        enable = true;
      };

      xkb = {
        # Turn Caps Lock into Ctrl
        layout = "us";
        options = "ctrl:nocaps";
      };
    };

    # Better support for general peripherals
    libinput.enable = true;

    # Let's be able to SSH into this machine
    openssh.enable = true;

    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  # Enable sound
  # sound.enable = true;

  # Video support
  hardware = {
    graphics.enable = true;
    # pulseaudio.enable = true;
    # hardware.nvidia.modesetting.enable = true;

    # Enable Xbox support
    # hardware.xone.enable = true;

    # Crypto wallet support
    ledger.enable = true;
  };

  # Add docker daemon
  virtualisation = {
    docker = {
      enable = true;
      logDriver = "json-file";
    };
  };

  # It's me, it's you, it's everyone
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = sshKeys;
    };

    root = {
      openssh.authorizedKeys.keys = sshKeys;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-emoji
  ];

  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "21.05"; # Don't change this
}
