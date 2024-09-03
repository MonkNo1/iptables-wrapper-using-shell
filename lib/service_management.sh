#!/bin/bash

source "lib/define.sh"
source "lib/rule_handling.sh"

service_handling() {
    clear
    while [ true ]; do
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_YELLOW}Service Mangement${RESET}"
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        for option in "${serop[@]}"; do
            echo -e "${BRIGHT_WHITE} ${option}${RESET}"
        done

        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        read choice
        case $choice in
        1)
            service_handl "http" 80
            ;;
        2)
            service_handl "https" 443
            ;;
        3)
            service_handl "ssh" 22
            ;;
        4)
            service_handl "ftp" 21
            ;;
        5)
            service_sftp
            ;;
        6)
            service_handl "smtp" 25
            ;;
        7)
            service_handl "pop" 110
            ;;
        8)
            service_handl "imap" 143
            ;;
        9)
            service_handl "telnet" 143
            ;;
        10)
            service_handl "dns" 143
            ;;
        11)
            service_handl "tftp" 143
            ;;
        12)
            service_handl "Win RPC" 143
            ;;
        13)
            service_handl "Win Netbios" 143
            ;;
        14)
            handle_services
            ;;
        15)
            break
            ;;
        *) echo -e "${RED} Enter the correct Option ${RESET}" ;;
        esac
    done
}
