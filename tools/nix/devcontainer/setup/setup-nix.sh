#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2015
set -u
set -e
set -o pipefail

. "$CONTAINER_SETUP_DIR/common/log.sh"

function setup_nix() {
    print_info "Install Nix."

    sh <(curl -L https://nixos.org/nix/install) --no-daemon

    print_info "Enable Features for Nix."
    mkdir -p ~/.config/nix
    {
        echo "experimental-features = nix-command flakes"
        echo "accept-flake-config = true"
    } >~/.config/nix/nix.conf

    # Currently the podman/systemd multi-user install
    # with determinant does not work
    # curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
    #     --extra-conf "sandbox = false" \
    #     --no-start-daemon \
    #     --no-confirm
}

setup_nix "$@"
