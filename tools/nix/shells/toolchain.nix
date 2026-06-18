# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  lib,
  pkgs,
  namespace,
  ...
}:
let
  # Packages for the 'default' shell.
  default =
    { config, ... }:
    {
      devcontainer.enable = false;

      packages = with pkgs; [
        just
        parallel
        direnv

        nodejs-slim_24
        pnpm

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

      env = {
        PNPM_HOME = "${config.devenv.state}/pnpm";
      };

      process.manager = {
        implementation = "process-compose";
      };

      process.managers = {
        process-compose = {
          package = pkgs.process-compose;
        };
      };

      processes = {
        serve = {
          exec = "just present";
          process-compose = {
            depends_on = {
              init = {
                condition = "process_healthy";
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
                # FIXME: Cannot say: completed, cause devenv-task does not complete.
                # https://github.com/cachix/devenv/issues/2879
                condition = "process_healthy";
              };
            };
          };
        };
        init =
          let
            readyScript =
              pkgs.writeShellScriptBin "init-complete"
                # Bash
                ''
                  ls build/.init-complete || exit 1
                  exit 0
                '';
          in
          {
            exec = "just init";
            ready = {
              exec = "${lib.getExe readyScript}";
              initial_delay = 4;
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
