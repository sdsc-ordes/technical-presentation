#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2015
set -e
set -u
set -o pipefail

. "$CONTAINER_SETUP_DIR/common/log.sh"
. "$CONTAINER_SETUP_DIR/common/platform.sh"

LOCALE=""

# Parse all arguments.
function parseArgs() {

    local prev=""

    for p in "$@"; do
        if [ "$p" = "--locale" ]; then
            true
        elif [ "$prev" = "--locale" ]; then
            LOCALE="$p"
        else
            echo "Wrong argument '$p' !"
            return 1
        fi
        prev="$p"
    done

    return 0
}

parseArgs "$@"

os=""
os_dist=""
get_platform_os os os_dist

function get_locales() {
    echo "de_CH
de_DE
en_US"
}

[ -n "$LOCALE" ] || die "Local '--locale' need to be set."

function run() {
    print_info "Configuring locale '$LOCALE' & '$(get_locales)' ..."

    if [ "$os" = "linux" ] &&
        [ "$os_dist" = "ubuntu" ]; then

        sudo apt-get update &&
            sudo apt-get -y install locales || die "Could not install 'locales'."

        get_locales | xargs -I {} sudo locale-gen --no-purge '{}.UTF-8' &&
            sudo locale-gen --no-purge "$LOCALE.UTF-8" &&
            print_info "Update locales ..." &&
            sudo update-locale "LANG=$LOCALE.UTF-8" &&
            echo "locales" "locales/locales_to_be_generated" "multiselect" "$LOCALE.UTF-8" UTF-8 | sudo debconf-set-selections &&
            echo "locales" "locales/default_environment_locale" "select" "$LOCALE.UTF-8" | sudo debconf-set-selections &&
            print_info "Reconfiguring locales ..." &&
            sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales ||
            die "Could not configure locales. Retry building by providing" \
                "a '.env' file from the template file '.env.tmpl'."

    elif [ "$os" = "linux" ] &&
        [ "$os_dist" = "alpine" ]; then
        # nothing to do...
        true
    else
        osNotSupported "$os"
    fi
}

run

print_info "Export" \
    " - 'LANG=$LOCALE.UTF-8'" \
    " - 'LANGUAGE=$LOCALE.UTF-8'" \
    " - 'LC_ALL=$LOCALE.UTF-8'" \
    "system-wide to make use of it."

export LANG="$LOCALE.UTF-8"
export LANGUAGE="$LOCALE.UTF-8"
export LC_ALL="$LOCALE.UTF-8"
