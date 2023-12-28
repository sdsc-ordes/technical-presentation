{
  description = "Homepage Dev";

  nixConfig = {
    substituters = [
      # Add here some other mirror if needed.
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-23.11";
    # Also see the 'stable-packages' overlay at 'overlays/default.nix'.

    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgsStable,
    flake-utils,
    rust-overlay,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    # Creates an attribute map `{ devShells.<system>.default = ...}`
    # by calling this function:
    (
      system: let
        # Import nixpkgs and load it into pkgs.
        pkgs = import nixpkgs {
          inherit system;
        };

        # Things needed only at compile-time.
        nativeBuildInputsBasic = with pkgs; [
          just
          parallel
          nodePackages_latest.npm
        ];

        # Things needed only at compile-time.
        nativeBuildInputsDev = with pkgs; [
        ];

        # Things needed at runtime.
        buildInputs = with pkgs; [postgresql];
      in
        with pkgs; {
          devShells = {
            default = mkShell {
              inherit buildInputs;
              nativeBuildInputs = nativeBuildInputsBasic ++ nativeBuildInputsDev;
            };
          };
        }
    );
}
