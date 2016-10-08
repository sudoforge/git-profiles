#!/usr/bin/env sh

which_func() {
    local filename=$1 path_to_check
    for path_to_check in $(echo $PATH | sed 's/:/ /g'); do
        if [ -x "$path_to_check/$filename" ]; then
            echo "$path_to_check/$filename"
            return 0
        fi
    done
    return 1
}

GIT_PROFILES_GIT_COMMAND=""
if which_func git > /dev/null 2>&1; then
    GIT_PROFILES_GIT_COMMAND=$(which_func git)
fi

git() {
    if [ ! -e "${GIT_PROFILES_GIT_COMMAND}" ]; then
        echo "Git does not seem to be installed. Exiting."
        exit 1
    fi

    # Check to see if we have a valid .gitprofile
    local locations="${GIT_PROFILES_GIT_COMMAND} config --global --get-all profiles.path"
    local current_dir=""
    for location in $(eval "${locations}"); do
        current_dir=$(echo "${PWD}" | sed -r 's;^'"${location}"';;')
        
        if [ "${current_dir}" != "${PWD}" ] && [ -z "${gitprofile}" ]; then
            if [ -f "${location}/.gitprofile" ]; then
                local gitprofile="${location}/.gitprofile"
            fi
        fi
    done

    # Add the profile path to the global [include] section 
    local added_path=false
    if [ ! -z "${gitprofile}" ]; then
        local check=$("${GIT_PROFILES_GIT_COMMAND}" config --global --get-all include.path | grep "${gitprofile}")

        if [ "${check}" != "${gitprofile}" ]; then
            local added_path=true
            eval "${GIT_PROFILES_GIT_COMMAND} config --global --add include.path ${gitprofile}"
        fi
    fi

    # Execute the commands passed into this function
    eval "${GIT_PROFILES_GIT_COMMAND} ${@}"

    # Clean up the global [include] section
    if [ "${added_path}" = true ]; then
        eval "${GIT_PROFILES_GIT_COMMAND} config --global --unset include.path ${gitprofile}"

        local paths=$("${GIT_PROFILES_GIT_COMMAND}" config --global --get-all include.path)
        if [ "${paths}" = "" ]; then
            eval "${GIT_PROFILES_GIT_COMMAND} config --global --remove-section include"
        fi
    fi
}
