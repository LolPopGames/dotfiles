#!/bin/sh
# Escaping Strings Module
if [ -z "$_escaping_sh__included" ]; then
_escaping_sh__included=1

# Usage:
#   backslash_escape 'text'
# Description:
#   Escapes all backslashes with a backslash
backslash_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g'
}

# Usage:
#   shell_escape_quote 'text' # Description:
#   Escapes 'text' for double quotes use
# Example:
#   $(shell_escape_quote '$text\') == '\$text\\'
shell_escape_quote() {
    printf '%s' "$1" | sed "s/[\\\\\'\"\$\!]/\\\\&/g"
}

# Usage:
#   shell_escape 'text'
# Description:
#   Escapes 'text' for shell using
# Example:
#   $(shell_escape '$some text^&\') == '\$some\ text\^\&\\'
shell_escape() {
    printf '%s' "$1" | sed "s/[][\\\\\'\"^\$(){}*?\!&|#\`;<> [:space:]]/\\\\&/g"
}

# Usage:
#   sed_spattern_escape 'text'
# Description:
#   Escapes pattern string (left part) of the 's' command in sed
# Example:
#   $(sed_spattern_escape '\.*[some text^$/') == '\\\.\*\[some text\^\$\/'
sed_spattern_escape() {
    printf '%s' "$1" | sed 's/[\\.[*^$\/]/\\&/g'
}

# Usage:
#   sed_sreplace_escape 'text'
# Description:
#   Escapes replace string (right part) of the 's' command in sed
# Example:
#   $(sed_spattern_escape '\&some text/') == '\\\&some text\/'
sed_sreplace_escape() {
    printf '%s' "$1" | sed 's/[\\&\/]/\\&/g'
}

fi
