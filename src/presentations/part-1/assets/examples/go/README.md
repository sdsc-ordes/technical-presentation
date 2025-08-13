# Go example

## Development shell

This example go module comes with a nix flake that provides a go development
shell. This ensures all developers work with the same toolchain and tooling
versions (language server, linter, ...).

Enter the devShell with `nix develop --impure .` and then build the go package
with `go build main.go`.

Inspect the devshell setup by looking at `flake.nix` and `nix/go.nix`.

## Nix builds

In addition, you may look at `nix/package.nix` for a nix definition that
directly builds the package binary. The package can be built with nix using
`nix build nix/package.nix`

If we go further, this definition could be used as output by the flake.nix, and
even injected into a container image built with nix.
