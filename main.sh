#!/bin/bash

# ==============================
# DEVOPS AUTOMATION TOOL - RESPONSIVE
# ==============================

. core/ui.sh
. core/os.sh
. core/utils.sh
. plugins/nginx/install.sh

# Function to catch window resize
on_resize() {
    ui_init
    show_main_menu
}

# Trap the SIGWINCH signal (Window Size Change)
trap on_resize SIGWINCH

show_main_menu() {
    ui_init
    if [ "$IS_TOO_SMALL" -eq 1 ]; then
        ui_too_small
        return
    fi
    
    clear
    M1=$(get_status nginx)
    M2=$(get_status apache2)
    M3=$(get_status mariadb)
    M4=$(get_status docker)

    ui_border_top
    echo -ne "${CYAN}║${RESET}" ; center_text "${BOLD}🚀 SKYDEVOPS TOOLKIT v1.0.0${RESET}" ; echo -e "${CYAN}║${RESET}"
    ui_border_mid
    ui_line "${YELLOW}Giới thiệu:${RESET} Công cụ cài đặt & quản trị (Multi-OS: Ubuntu/CentOS)"
    ui_line "Hệ quản trị DevOps & SysAdmin chuyên nghiệp"
    ui_empty
    ui_row_3col "${BOLD}CÀI ĐẶT${RESET}" "${BOLD}TỐI ƯU${RESET}" "${BOLD}KIỂM TRA${RESET}"
    ui_row_3col "1. NGINX   [$M1]" "5. Tối ưu Nginx" "9. Check Log Nginx"
    ui_row_3col "2. APACHE2 [$M2]" "6. Tối ưu MariaDB" "10. Check MariaDB"
    ui_row_3col "3. MARIADB [$M3]" "7. Tối ưu System" "11. System Status"
    ui_row_3col "4. DOCKER  [$M4]" "8. Tối ưu Network" "12. Port Listening"
    ui_empty
    ui_line "[0] Thoát"
    ui_border_mid
    ui_line "By thanhnh | https://thanhnh.id.vn"
    ui_border_bottom
    ui_input
}

handle_choice() {
    [ -z "$1" ] && return
    case $1 in
        1) nginx_menu ;;
        2|3|4|5|6|7|8|9|10|11|12)
            echo -e "${YELLOW}Tính năng này sẽ sớm được hoàn thiện...${RESET}"
            sleep 1
            ;;
        0)
            echo -e "${CYAN}Cảm ơn bạn đã sử dụng. Hẹn gặp lại!${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ!${RESET}"
            sleep 0.5
            ;;
    esac
}

# Main Loop
detect_os
while true; do
    show_main_menu
    # Loop read if input is empty (e.g. after a signal)
    choice=""
    read -r choice
    handle_choice "$choice"
done