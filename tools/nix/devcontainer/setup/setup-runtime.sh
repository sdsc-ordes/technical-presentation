#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2015
set -u
set -e
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
. "$CONTAINER_SETUP_DIR/common/log.sh"

function setup() {

    GPG_TTY=$(tty) ||
        print_warning "Could not execute 'tty' to set 'GPG_TTY'."
    [ -n "$GPG_TTY" ] && export GPG_TTY

    local cacheFile="$DIR/.setup-runtime-done"
    local forceFile="$DIR/.setup-runtime-force"
    local skipFile="$DIR/.setup-runtime-skip"

    if { [ -f "$cacheFile" ] &&
        [ "${FORCE_RUNTIME_SETUP:-}" != "true" ] &&
        [ ! -f "$forceFile" ]; } ||
        { [ -f "$skipFile" ] ||
            [ "${FORCE_SKIP_RUNTIME_SETUP:-}" = "true" ]; }; then
        print_info "Setup runtime already done." \
            "Existing file '$cacheFile'."
        return 0
    fi

    # Set docker socket permissions
    if [ -S /var/run/docker.sock ]; then
        print_info "Setting user group on docker socket '/var/run/docker.sock'."
        local user
        user=$(whoami) || die "Could not get user name."
        sudo chown "$user:$user" /var/run/docker.sock ||
            die "Could not set permissions."
    fi

    # Create history file in mounted directory.
    if [ -d ~/.shell ]; then
        print_info "Setting zsh history to '~/.shell/.zsh_history'."
        touch ~/.shell/.zsh_history &&
            sed -i -E "s@^HISTFILE=.*\$@HISTFILE=~/.shell/.zsh_history@" ~/.zshrc || {
            print_error "Could not set HISTFILE to '~/.shell/.zsh_history' in '~/.zshrc'. "
        }
    fi

    # Timezone setup.
    if [ -n "${TIME_ZONE:-}" ]; then
        "$CONTAINER_SETUP_DIR/setup-time-zone.sh" \
            "--non-interactive" \
            --time-zone "$TIME_ZONE" || die "Could not setup timezone."
    fi

    # Custom setups for other stuff in containers.
    if [ -d "$CONTAINER_SETUP_DIR/runtime" ]; then
        for script in "$CONTAINER_SETUP_DIR/runtime"/*.sh; do
            print_info "Run setup in '$script' ..."

            "$script" ||
                die "Setup runtime script '$script' failed"
        done
    fi

    echo "setup-runtime.sh successful" >"$cacheFile"
    print_info "Container setup successful."
    return 0
}

setup 2>&1 | tee "$CONTAINER_SETUP_DIR/.setup-runtime.log"

exec "$@"
