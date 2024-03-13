set positional-arguments
set shell := ["bash", "-cue"]
root_dir := justfile_directory()

install:
    npm run install

present:
    npm run present

package:
    npm run package

bake-logo:
  cd "{{root_dir}}" && \
    repl=$(cat css/theme/source/files/company-logo.svg | base64 -w 0| sed "s/\+/\\\+/g") && \
    sed -i -E "s@background-image(.*);base64,.*\"@background-image\1;base64,$repl\"@" css/theme/source/company.scss
