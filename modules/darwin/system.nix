{ ... }:

{
  # Touch ID for sudo
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true; # Needed for tmux/screen
  };

  # Other system-level settings can go here
  system.defaults = {
    # Example: dock settings, finder preferences, etc.
  };
}
