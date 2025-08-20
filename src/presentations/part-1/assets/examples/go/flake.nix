{
  description = "Go project with a development and package derivation";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # or another channel
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    devenv,
  }: let
    forAllSystems = import ./nix/systems.nix;
  in {
    packages = forAllSystems {
      pkgs = nixpkgs;
      f = import ./nix/package.nix;
    };

    devShells = forAllSystems {
      pkgs = nixpkgs;
      f = {pkgs, ...}: {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = import ./nix/go.nix {inherit pkgs;};
        };
      };
    };
  };
}
