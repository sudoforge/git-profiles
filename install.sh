#!/usr/bin/env sh

addToRunCom() {
    if [ -e "${1}" ]; then
        local check=$(cat "${1}" | grep "${2}")

        if [ "${check}" = "" ]; then
            echo "${2}" >> "${1}"
        fi
    fi
}

main() {
    for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.mkshrc"; do
        addToRunCom "${f}" "source ${PWD}/git-directory-profiles.sh"
    done
}

main