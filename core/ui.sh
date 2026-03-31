#!/bin/bash

# ==============================
# 100x50 OPTIMIZED UI FRAMEWORK
# ==============================

ESC=$(printf '\033')
RESET="${ESC}[0m"
BOLD="${ESC}[1m"
CYAN="${ESC}[0;36m"
GREEN="${ESC}[0;32m"
YELLOW="${ESC}[1;33m"
RED="${ESC}[0;31m"

MIN_WIDTH=100

# Initialize UI dimensions
ui_init() {
    # Attempt to request terminal resize to 100x50 (supported by many terminal emulators)
    echo -ne "${ESC}[8;50;100t"

    local term_w=$(tput cols 2>/dev/null)
    [ -z "$term_w" ] && term_w=100
    
    IS_TOO_SMALL=0

    # Cap width at 100 or adapt dynamically
    if [ "$term_w" -gt 100 ]; then
        WIDTH=100
    else
        WIDTH=$term_w
    fi
    
    INNER_WIDTH=$(( WIDTH - 2 ))
    COL_WIDTH=$(( (INNER_WIDTH - 8) / 3 ))
}

ui_too_small() {
    clear
    local term_w=$(tput cols 2>/dev/null || echo 80)
    echo -e "${RED}${BOLD}"
    echo "  TERMINAL TOO SMALL ($term_w < $MIN_WIDTH)"
    echo "  Please resize your terminal window to at least 100x50."
    echo -e "${RESET}"
}

strip_ansi() {
    echo -n "$1" | sed "s/${ESC}\[[0-9;]*[mK]//g"
}

truncate_text() {
    local text="$1"
    local max_w="$2"
    local visible=$(strip_ansi "$text")
    if [ ${#visible} -gt $max_w ]; then
        # Handle truncation carefully with ANSI
        echo -n "${text:0:$((max_w-3))}..."
    else
        echo -n "$text"
    fi
}

center_text() {
    local text="$1"
    local visible=$(strip_ansi "$text")
    local len=${#visible}
    local pad=$(( (INNER_WIDTH - len) / 2 ))
    local rpad=$(( INNER_WIDTH - len - pad ))

    [ $pad -lt 0 ] && pad=0
    [ $rpad -lt 0 ] && rpad=0

    printf "%${pad}s" ""
    echo -ne "$text"
    printf "%${rpad}s" ""
}

ui_border_top() {
    [ "$IS_TOO_SMALL" -eq 1 ] && return
    printf "${CYAN}╔"
    printf '═%.0s' $(seq 1 $INNER_WIDTH)
    printf "╗${RESET}\n"
}

ui_border_mid() {
    [ "$IS_TOO_SMALL" -eq 1 ] && return
    printf "${CYAN}╠"
    printf '═%.0s' $(seq 1 $INNER_WIDTH)
    printf "╣${RESET}\n"
}

ui_border_bottom() {
    [ "$IS_TOO_SMALL" -eq 1 ] && return
    printf "${CYAN}╚"
    printf '═%.0s' $(seq 1 $INNER_WIDTH)
    printf "╝${RESET}\n"
}

ui_line() {
    [ "$IS_TOO_SMALL" -eq 1 ] && return
    local text="$1"
    local visible=$(strip_ansi "$text")
    local len=${#visible}
    local pad=$((INNER_WIDTH - len - 2))
    [ $pad -lt 0 ] && pad=0

    echo -ne "${CYAN}║${RESET} "
    echo -ne "$text"
    printf "%${pad}s" ""
    echo -e " ${CYAN}║${RESET}"
}

ui_empty() {
    [ "$IS_TOO_SMALL" -eq 1 ] && return
    echo -ne "${CYAN}║${RESET}"
    printf "%${INNER_WIDTH}s" ""
    echo -e "${CYAN}║${RESET}"
}

ui_row_3col() {
    [ "$IS_TOO_SMALL" -eq 1 ] && return
    
    local remainder=$(( INNER_WIDTH - (COL_WIDTH * 3 + 8) ))
    local col3_w=$(( COL_WIDTH + remainder ))

    local c1=$(truncate_text "$1" $COL_WIDTH)
    local c2=$(truncate_text "$2" $COL_WIDTH)
    local c3=$(truncate_text "$3" $col3_w)

    local v1=$(strip_ansi "$c1")
    local v2=$(strip_ansi "$c2")
    local v3=$(strip_ansi "$c3")

    printf "${CYAN}║${RESET} "
    printf "%s" "$c1"; printf "%$((COL_WIDTH - ${#v1}))s" ""
    printf " ${CYAN}│${RESET} "
    printf "%s" "$c2"; printf "%$((COL_WIDTH - ${#v2}))s" ""
    printf " ${CYAN}│${RESET} "
    printf "%s" "$c3"; printf "%$((col3_w - ${#v3}))s" ""
    printf " ${CYAN}║${RESET}\n"
}

ui_input() {
    echo -ne "\n${BOLD}➜ Nhập lựa chọn:${RESET} "
}

get_status() {
    local app=$1
    if command -v "$app" >/dev/null 2>&1; then
        local ver=""
        case $app in
            nginx) ver=$(nginx -v 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') ;;
            docker) ver=$(docker -v | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
            mariadb) ver=$(mariadb -V 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') ;;
            apache2) ver=$(apache2 -v 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') ;;
        esac
        [ -n "$ver" ] && echo -e "${GREEN}✔ v$ver${RESET}" || echo -e "${GREEN}✔${RESET}"
    else
        echo " "
    fi
}
