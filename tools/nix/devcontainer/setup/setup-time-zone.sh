#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2015
set -e
set -u
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
. "$DIR/common/log.sh"
. "$DIR/common/platform.sh"

time_zone=""

# Parse all arguments.
function parse_args() {

    local prev=""

    for p in "$@"; do
        if [ "$p" = "--time-zone" ]; then
            true
        elif [ "$prev" = "--time-zone" ]; then
            time_zone="$p"
        else
            echo "Wrong argument '$p' !"
            return 1
        fi
        prev="$p"
    done

    return 0
}

parse_args "$@"

os=""
osDist=""
get_platform_os os osDist

print_info "Configuring time zone '$time_zone' ..."

if [ "$os" = "linux" ] &&
    [ "$osDist" = "alpine" ]; then

    sudo apk add tzdata || die "Could not install 'tzdata'."

    echo "Configure time zone to $time_zone"
    if [ "$(cat '/etc/timezone' 2>/dev/null)" != "$time_zone" ]; then
        sudo ln -snf "/usr/share/zoneinfo/$time_zone" /etc/localtime && echo "$time_zone" | sudo tee /etc/timezone
    fi

else
    die "Operating system not supported:" "$os"
fi
