{
  description = "Go project with devShell and build, no flake-utils";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # or another channel
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    devenv,
  }: let
    supportedSystems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    packages = forAllSystems (
      {pkgs, ...}: let
        goSrc = pkgs.lib.fileset.toSource {
          root = ./.;
          fileset = pkgs.lib.fileset.gitTracked ./.;
        };
      in {
        default = pkgs.buildGoModule {
          pname = "go-demo";
          version = "0.1.0";
          src = goSrc;
          modRoot = ".";
          vendorHash = null;
        };
      }
    );

    devShells = forAllSystems ({pkgs, ...}: {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = import ./nix/go.nix {inherit pkgs;};
      };
    });
  };
}
