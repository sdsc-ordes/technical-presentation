#!/usr/bin/env bash
set -u
set -e

file="index.html"
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

chrome=""
chrome_paths=()

if [[ $OSTYPE == "linux-gnu" ]]; then
    chrome_paths=("google-chrome" "google-chrome-stable")
    user_data_dir=~/.config/google-chrome/Default
elif [[ $OSTYPE == "darwin"* ]]; then
    chrome_paths=("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
    user_data_dir=~"/Library/Application Support/Google Chrome/Default"
elif [[ $OSTYPE == "msys" ]]; then
    chrome_paths=("C:/Program Files (x86)/Google/Chrome/Application/chrome.exe")
    user_data_dir=~/"AppData/Local/Google/Chrome/User Data/Default"
else
    echo "System not supported!"
    exit 1
fi

function open_chrome() {
    if [ ! -d "$user_data_dir" ]; then
        echo "User data dir not found: '$user_data_dir'."
        local user_data_dir="$current_dir/.user-data"
        mkdir -p "$user_data_dir"
    fi

    # Start Chrome without CORS
    if [[ $OSTYPE == "linux-gnu" ]] || [[ $OSTYPE == "msys" ]]; then
        "$chrome" --new-window --disable-web-security \
            -–allow-file-access-from-files \
            --user-data-dir="$user_data_dir" \
            "${current_dir}/${file}"

    elif [[ $OSTYPE == "darwin"* ]]; then
        open -n -a "$chrome" --args --new-window --disable-web-security \
            -–allow-file-access-from-files \
            --user-data-dir="$user_data_dir" \
            "${current_dir}/${file}"
    else
        echo "System not supported!"
        exit 1
    fi
}

function check_path() {
    chrome=""
    for path in "${chrome_paths[@]}"; do
        if command -v "$path" &>/dev/null; then
            chrome="$path"
        fi
    done

    while ! command -v "${chrome}" &>/dev/null 2>&1; do
        echo "I require 'Google Chrome' but not found in the following paths:" "${chrome_paths[@]}" >&2
        read -rp "Enter the path to Google Chrome: " chrome
    done
    echo "Found Google Chrome @ '${chrome}'"
}

check_path
open_chrome
