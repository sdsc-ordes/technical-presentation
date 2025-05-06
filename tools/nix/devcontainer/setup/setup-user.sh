#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2015
set -u
set -e
set -o pipefail

. "$CONTAINER_SETUP_DIR/common/log.sh"
. "$CONTAINER_SETUP_DIR/common/platform.sh"

USER_NAME="$1"
USER_UID="$2"
USER_GID="$3"

os=""
os_dist=""
get_platform_os os os_dist

USER_SHELL="/bin/bash"

print_info "Add user uid:'$USER_UID', gid'$USER_GID'"

if [ "$os" = "linux" ] &&
    [ "$os_dist" = "alpine" ]; then

    adduser "$USER_NAME" -s "$USER_SHELL" -D \
        -u "$USER_UID" -g "$USER_GID" -h "/home/$USER_NAME"

    mkdir -p /etc/sudoers.d &&
        echo "$USER_NAME ALL=(root) NOPASSWD:ALL" >"/etc/sudoers.d/$USER_NAME" &&
        chmod 0440 "/etc/sudoers.d/$USER_NAME"

elif [ "$os" = "linux" ] &&
    [ "$os_dist" = "ubuntu" ]; then

    # Newest Ubuntu has a user ubuntu with 1000
    userdel ubuntu || true

    groupadd -g "$USER_GID" "$USER_NAME"
    useradd -p "$(openssl passwd -1 "$USER_NAME")" \
        -m --shell "$USER_SHELL" \
        -u "$USER_UID" -g "$USER_GID" \
        -G sudo "$USER_NAME" &&
        passwd -d "$USER_NAME"

else
    die "Operating system not supported:" "$os"
fi

# Set some Nix permissions stuff.
# https://github.com/NixOS/nix/issues/3435#issuecomment-2305827610
# sudo mkdir -p /nix/var/nix/{profiles,gcroots}/per-user/"$USER_NAME"
# sudo chown "$USER_UID" /nix/var/nix/{profiles,gcroots}/per-user/"$USER_NAME"
# sudo chown -R "$USER_UID:$USER_GID" /nix/var
#
mkdir -p "$CONTAINER_SETUP_DIR/runtime"
chown -R "$USER_UID:$USER_GID" "/home/$USER_NAME" "$CONTAINER_SETUP_DIR"
