#!/usr/bin/env sh
# Marks Framework
if [ -z "$_parse_marks__included" ]; then
_parse_marks__included=1

mark_prefix=

# Usage:
#   parse_marks FILE
# Description:
#   Outputs to stdout the file with expanded #~~mark~~# marks.
#
#   When a #~~some~~# is finded it calls mark_some
#   It also supports arguments (e.g. #~~some a b c~~# will call mark_some a b c).
#
#   #~~set_prefix~~# mark will set a prefix for other marks:
#       #~~set_prefix pref~~##~~foo~~# #~~bar~~# will call mark_pref_foo and mark_pref_bar.
#
#   To reset prefix call #~~set_prefix~~# without arguments
parse_marks() (
    file="$(cat "$1"; printf x)"; file="${file%x}"

    while true; do
        case "$file" in
            *"#~~"*)
                printf '%s' "${file%%#~~*}"
                file="${file#*#~~}"
                mark="${file%%~~#*}"
                file="${file#*~~#}"

                set -- $mark
                if [ "$1" = 'set_prefix' ]; then
                    mark_prefix="$2"
                elif command -v "mark_${mark_prefix:+${mark_prefix}_}$1" >/dev/null 2>&1; then
                    mark_${mark_prefix:+${mark_prefix}_}${mark}
                fi;;
            *)
                printf '%s' "${file}"
                break;;
        esac
    done
)

fi
