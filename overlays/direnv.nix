# Disable direnv's check phase to avoid hanging integration tests in sandboxed builds.
# These tests spawn shells and can deadlock, particularly on macOS.
final: prev: {
  direnv = prev.direnv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
}
