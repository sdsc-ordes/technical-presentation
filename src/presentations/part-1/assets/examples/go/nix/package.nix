{pkgs, ...}: let
  goSrc = pkgs.lib.fileset.toSource {
    root = ../.;
    fileset = pkgs.lib.fileset.gitTracked ../.;
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
