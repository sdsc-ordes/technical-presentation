{
  inputs,
  pkgs,
  namespace,
  lib,
  ...
}:
pkgs.buildEnv {
  name = "devcontainer-deps";
  paths = [
    pkgs.${namespace}.bootstrap
    pkgs.binutils
    pkgs.bash
    pkgs.zsh

    pkgs.podman

    # zsh # TODO: Somehow I cannot get the plugins work with LC_ALL and locales.
    pkgs.figlet
    pkgs.glibcLocales
  ];
}
