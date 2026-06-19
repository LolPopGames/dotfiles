#!/bin/sh
# Colors Manipulation Module
if [ -z "$_colors_sh__included" ]; then
_colors_sh__included=1

# --- Color Constants ---
# Main
ESC="$(printf '\033')"
RESET="$ESC[0m"
BOLD="$ESC[1m"

# Normal colors
BLACK="$ESC[30m"
RED="$ESC[31m"
GREEN="$ESC[32m"
YELLOW="$ESC[33m"
BLUE="$ESC[34m"
MAGENTA="$ESC[35m"
CYAN="$ESC[36m"
WHITE="$ESC[37m"

# Background normal colors
BG_BLACK="$ESC[40m"
BG_RED="$ESC[41m"
BG_GREEN="$ESC[42m"
BG_YELLOW="$ESC[43m"
BG_BLUE="$ESC[44m"
BG_MAGENTA="$ESC[45m"
BG_CYAN="$ESC[46m"
BG_WHITE="$ESC[47m"

# Light colors
LIGHT_BLACK="$ESC[90m"
LIGHT_RED="$ESC[91m"
LIGHT_GREEN="$ESC[92m"
LIGHT_YELLOW="$ESC[93m"
LIGHT_BLUE="$ESC[94m"
LIGHT_MAGENTA="$ESC[95m"
LIGHT_CYAN="$ESC[96m"
LIGHT_WHITE="$ESC[97m"

# Background light colors
BG_LIGHT_BLACK="$ESC[100m"
BG_LIGHT_RED="$ESC[101m"
BG_LIGHT_GREEN="$ESC[102m"
BG_LIGHT_YELLOW="$ESC[103m"
BG_LIGHT_BLUE="$ESC[104m"
BG_LIGHT_MAGENTA="$ESC[105m"
BG_LIGHT_CYAN="$ESC[106m"
BG_LIGHT_WHITE="$ESC[107m"

# --- RGB to xterm256 Function ---
# Usage:
#   rgb_to_xterm256 R G B
# Description:
#   Converts RGB value to a value from xterm256 color pallete
#
#   R, G, B must be decimal numbers
rgb_to_xterm256() (
    r="$1" g="$2" b="$3"

    # --- Base16 ---
    # Indexes:
    #   0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white,
    #   8=light-black, 9=light-red, 10=light-green, 11=light-yellow, 12=light-blue, 13=light-magenta, 14=light-cyan, 15=light-white
    #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
    sys_r="46  204 78  227 32  117 6   211 85  239 128 252 114 173 52  238"
    sys_g="52  0   154 186 100 80  152 215 87  41  226 233 159 127 226 238"
    sys_b="54  0   6   9   164 123 154 207 83  41  52  79  207 168 226 236"

    min_dist=999999
    best=0
    i=0
    for token in $sys_r; do
        sr=$token
        sg=$(echo "$sys_g" | cut -d' ' -f$((i+1)))
        sb=$(echo "$sys_b" | cut -d' ' -f$((i+1)))
        dr=$((r - sr))
        dg=$((g - sg))
        db=$((b - sb))
        dist=$((dr*dr + dg*dg + db*db))
        if [ $dist -lt $min_dist ]; then
            min_dist=$dist
            best=$i
        fi
        i=$((i+1))
    done

    # --- Color Cube 6x6x6 (indexes 16-231) ---
    # Levels: 0, 95, 135, 175, 215, 255
    # Index = 16 + 386*ri + 6*gi + bi
    ri=0
    while [ $ri -lt 6 ]; do
        gi=0
        while [ $gi -lt 6 ]; do
            bi=0
            while [ $bi -lt 6 ]; do
                case $ri in
                    0) cr=0;; 1) cr=95;; 2) cr=135;;
                    3) cr=175;; 4) cr=215;; 5) cr=255;;
                esac
                case $gi in
                    0) cg=0;; 1) cg=95;; 2) cg=135;;
                    3) cg=175;; 4) cg=215;; 5) cg=255;;
                esac
                case $bi in
                    0) cb=0;; 1) cb=95;; 2) cb=135;;
                    3) cb=175;; 4) cb=215;; 5) cb=255;;
                esac
                dr=$((r - cr))
                dg=$((g - cg))
                db=$((b - cb))
                dist=$((dr*dr + dg*dg + db*db))
                idx=$((16 + 36*ri + 6*gi + bi))
                if [ $dist -lt $min_dist ]; then
                    min_dist=$dist
                    best=$idx
                fi
                bi=$((bi+1))
            done
            gi=$((gi+1))
        done
        ri=$((ri+1))
    done

    # --- Gray Scale (indexes 232-255) ---
    gray=0
    while [ $gray -lt 24 ]; do
        level=$((gray * 10 + 8))
        dr=$((r - level))
        dg=$((g - level))
        db=$((b - level))
        dist=$((dr*dr + dg*dg + db*db))
        idx=$((232 + gray))
        if [ $dist -lt $min_dist ]; then
            min_dist=$dist
            best=$idx
        fi
        gray=$((gray+1))
    done

    echo "$best"
)

# --- xterm256 to RGB Function ---
# Usage:
#   xterm256_to_base16 XTERM-COLOR
# Description:
#   Converts XTERM-COLOR to rgb color
# Output Format:
#   R G B
#   R, G, B are decimal numbers
xterm256_to_rgb() (
    xterm_color="$1"
    # --- Base16 ---
    if [ "$xterm_color" -lt 16 ]; then
        # Indexes:
        #   0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white,
        #   8=light-black, 9=light-red, 10=light-green, 11=light-yellow, 12=light-blue, 13=light-magenta, 14=light-cyan, 15=light-white
        #      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
        sys_r="46  204 78  227 32  117 6   211 85  239 128 252 114 173 52  238"
        sys_g="52  0   154 186 100 80  152 215 87  41  226 233 159 127 226 238"
        sys_b="54  0   6   9   164 123 154 207 83  41  52  79  207 168 226 236"
        i=$((idx+1))
        r=$(printf "$sys_r" | cut -d' ' -f$i)
        g=$(printf "$sys_g" | cut -d' ' -f$i)
        b=$(printf "$sys_b" | cut -d' ' -f$i)

    # --- Color Cube 6x6x6 (indexes 16-231) ---
    elif [ $xterm_color -lt 232 ]; then
        # Levels: 0, 95, 135, 175, 215, 255
        # Index = 16 + 386*ri + 6*gi + bi
        tmp=$((xterm_color - 16))
        ri=$((tmp / 36))
        gi=$(((tmp % 36) / 6))
        bi=$((tmp % 6))
        case $ri in
            0) r=0;; 1) r=95;; 2) r=135;;
            3) r=175;; 4) r=215;; 5) r=255;;
        esac
        case $gi in
            0) g=0;; 1) g=95;; 2) g=135;;
            3) g=175;; 4) g=215;; 5) g=255;;
        esac
        case $bi in
            0) b=0;; 1) b=95;; 2) b=135;;
            3) b=175;; 4) b=215;; 5) b=255;;
        esac

    # --- Gray Scale (indexes 232-255) ---
    else
        level=$(( (idx - 232) * 10 + 8 ))
        r=$level; g=$level; b=$level
    fi
    printf "$r $g $b"
)

# --- RGB to Base16 Function ---
# Usage:
#   rgb_to_xterm256 R G B
# Description:
#   Converts RGB value to a value from xterm256 color pallete
#
#   R, G, B must be decimal numbers
rgb_to_base16() (
    r="$1" g="$2" b="$3"

    # --- Pallete ---
    pal_0="46 52 54"
    pal_1="204 0 0"
    pal_2="239 41 41"
    pal_3="227 186 9"
    pal_4="52 100 164"
    pal_5="117 80 123"
    pal_6="6 152 154"
    pal_7="211 215 207"
    pal_8="85 87 83"
    pal_9="239 41 41"
    pal_10="138 226 52"
    pal_11="252 233 79"
    pal_12="114 159 207"
    pal_13="173 127 168"
    pal_14="52 226 226"
    pal_15="238 238 236"

    min_dist=999999 best=0 base=0
    while [ $base -lt 16 ]; do
        eval "pal=\$pal_$base"
        pr=${pal%% *}
        pg=${pal#* }; pg=${pg%% *}
        pb=${pal##* }

        dr=$((r - pr))
        dg=$((g - pg))
        db=$((b - pb))
        dist=$((dr*dr + dg*dg + db*db))
        if [ $dist -lt $min_dist ]; then
            min_dist=$dist
            best=$base
        fi

        base=$((base + 1))
    done

    printf "$best"
)

# --- xterm256 to Base16 Function ---
# Usage:
#   xterm256_to_base16 XTERM-COLOR
# Description:
#   Converts XTERM-COLOR to base16 color
xterm256_to_base16() (
    xterm_color="$1"

    # --- Converting xterm256 to RGB ---
    rgb=$(xterm256_to_rgb "$xterm_color")
    r=${rgb%% *}
    g=${rgb#* }; g=${g%% *}
    b=${rgb##* }

    rgb_to_base16 "$r" "$g" "$b"
)

fi
