{pkgs, ...}: let
  # This is equivalent to `goSrc = ./.` but the [`fileset`](https://noogle.dev/q?term=lib.fileset) library gives more
  # flexibility to construct source derivations used in the below build support function `buildGoModule`.
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
