{
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}@args:
let
in
# Create the 'bootstrap' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    {
      packages = [
        pkgs.${namespace}.bootstrap
        pkgs.${namespace}.treefmt
      ];
    }
  ];
}
