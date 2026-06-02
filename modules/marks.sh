#!/usr/bin/env sh
# Marks Framework
if [ -z "$_parse_marks__included" ]; then
_parse_marks__included=1

mark_prefix=

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
