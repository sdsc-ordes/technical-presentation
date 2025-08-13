# package.nix
# builds go executable.
{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "go-demo";
  version = "0.1.0";

  src = ../.;

  vendorHash = pkgs.lib.fakeHash;
}
