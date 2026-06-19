#!/bin/sh
# Dependencies Manipulation Module
if [ -z "$_deps_sh__included" ]; then
_deps_sh__included=1

# Usage:
#   dep_present DEP
# Description
#   Checks if a dependency presents,
#   uses callback if ${DEP}_present is defined
dep_present() {
    f_name=$(printf '%s' "$1" | sed 's/-/_/g')
    if command -v "${f_name}_present" >/dev/null 2>&1; then
        eval "${f_name}_present"
    else
        command -v "$1" >/dev/null 2>&1
    fi
    return $?
}

polkit_gnome_present() {
    [ -d /lib/polkit-gnome ]
}
wl_clipboard_present() {
    command -v wl-copy >/dev/null 2>&1
}
gvim_present() {
    command -v vim >/dev/null 2>&1
}


fi
