set positional-arguments
set shell := ["bash", "-cue"]
root_dir := justfile_directory()

install:
    npm run install

present:
    npm run present

package:
    npm run package

bake-logo mime="svg":
  cd "{{root_dir}}" && \
  	tools/bake-logo.sh "{{mime}}"
