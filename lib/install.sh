#!/usr/bin/env sh
GIT_PROFILES_INSTALLED="false"

addToRunCom() {
    if [ -e "${1}" ]; then
        GIT_PROFILES_INSTALLED="true"
        local check=$(cat "${1}" | grep "${2}")

        if [ "${check}" = "" ]; then
            echo "- Adding to ${1}..."
            echo "${2}" >> "${1}"
        else
            echo "- Found in ${1}"
        fi
    else
        echo "- Skipped ${1}..."
    fi
}

main() {
    echo
    echo "Installing git-profiles..."
    echo
    for f in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.mkshrc"; do
        addToRunCom "${f}" "source ${PWD}/git-profiles.sh"
    done

    echo
    if [ "${GIT_PROFILES_INSTALLED}" = true ]; then
        echo "Installation complete."
        echo "Restart your shell (or start a new session)!"
    else
        echo "It does not look like the install completed successfully."
        echo "Please create an issue with the output of \"echo \$SHELL\""
        echo
        echo "    https://github.com/bddenhartog/git-profiles/issues"
    fi
    echo
}

main