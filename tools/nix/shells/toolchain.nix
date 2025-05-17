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
    devcontainer.enable = false;

    packages = with pkgs; [
      just
      parallel
      direnv

      nodePackages_latest.pnpm

      pandoc
      pandoc-include
      haskellPackages.citeproc
      haskellPackages.pandoc-crossref

      python312

      watchman
      python312Packages.pywatchman

      svgbob
      mermaid-cli

      yq-go

      pkgs.${namespace}.treefmt
    ];

    process.manager.implementation = "process-compose";
    processes = {
      serve = {
        exec = "just present";
        process-compose = {
          depends_on = {
            init = {
              condition = "process_completed_successfully";
            };
            watch = {
              condition = "process_started";
            };
          };
        };
      };
      watch = {
        exec = "just watch";
        process-compose = {
          availability = {
            restart = "always";
            backoff_seconds = 10;
          };
          depends_on = {
            init = {
              condition = "process_completed_successfully";
            };
          };
        };
      };
      init = {
        exec = "just init";
        process-compose = {
        };
      };
    };
  };

  # Packages for the 'ci' shell.
  ci = default;
in
{
  inherit default ci;
}
