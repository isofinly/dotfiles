sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo launchctl kickstart -k system/org.nixos.darwin-store

sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl kickstart -k system/org.nixos.nix-daemon

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

