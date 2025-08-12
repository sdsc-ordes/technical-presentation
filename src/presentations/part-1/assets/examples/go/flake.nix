{
  description = "A golang devShell example";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    devenv,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        goModules = import ./go.nix {
          inherit pkgs;
        };
      in {
        devShells.default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = goModules;
        };
      }
    );
}
