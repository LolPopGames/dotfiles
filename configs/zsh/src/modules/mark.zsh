# Mark interface implementation

# Usage:
#   mark-parse FILE
#
# Description:
#   Prints file, but expands ###NAME### marks via calling mark-NAME functions
mark-parse() {
    local file="$(<"$1")"

    while [[ -n "$file" ]]; do
        # Printing part before mark
        printf '%s' "${file%%\#\#\#*}"
        # Removing before-mark part
        file="${file#*\#\#\#}"

        # Calling mark-NAME function
        "mark-${file%%\#\#\#*}"
        # Removing mark
        file="${file#*\#\#\#}"
    done
}
