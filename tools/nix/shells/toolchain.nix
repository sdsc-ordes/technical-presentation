# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  inputs,
  pkgs,
  namespace,
  ...
}:
let
  # Packages for the 'default' shell.
  default = {
    packages = with pkgs; [
      just
      parallel
      direnv

      nodePackages_latest.npm
      nodePackages_latest.yarn

      pandoc
      pandoc-include
      haskellPackages.citeproc
      haskellPackages.pandoc-crossref

      python312

      watchman
      python312Packages.pywatchman

      svgbob
      mermaid-cli

      pkgs.${namespace}.treefmt
    ];
  };

  # Packages for the 'ci' shell.
  ci = default;
in
{
  inherit default ci;
}
