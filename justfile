set positional-arguments
set shell := ["bash", "-cue"]
root_dir := justfile_directory()

# Enter a `nix` development shell.
nix-develop:
    nix develop ./nix#default

# Install all stuff.
install:
    npm install

# Present the presentation.
present:
    npm run present

# Package the presentation.
package:
    npm run package

# Bake the logo into the style-sheets.
bake-logo mime="svg":
  cd "{{root_dir}}" && \
  	tools/bake-logo.sh "{{mime}}"
