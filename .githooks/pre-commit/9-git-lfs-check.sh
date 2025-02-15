#!/usr/bin/env bash
# shellcheck disable=SC1091
#
# Format all files.

set -e
set -u
set -o pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR/.common.sh"

./tools/ci/check-git-lfs.sh
