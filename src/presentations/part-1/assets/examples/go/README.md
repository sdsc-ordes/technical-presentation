# Go example

## Development Shell

This example go module comes with a nix flake that provides a go development
shell. This ensures all developers work with the same toolchain and tooling
versions (language server, linter, ...).

Enter the devShell with `nix develop --impure .` and then build the go package
with `go build main.go`.

Inspect the devshell setup by looking at `flake.nix` and `nix/go.nix`.

## Nix builds

In addition, the flake declares a package in its output to directly build the go
binary. The package can be built with nix using `nix build`

If we go further, we could add a container image as flake output, and inject the
binary into it.
