#!/bin/bash

source "lib/define.sh"
source "lib/rule_handling.sh"
source "lib/service_management.sh"

rule_mand() {
    clear
    while [ true ]; do
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_YELLOW}Rule Mangement${RESET}"
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        for option in "${ruleop[@]}"; do
            echo -e "${BRIGHT_WHITE} ${option}${RESET}"
        done

        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        read choice
        case $choice in
        1)
            load_rules
            ;;
        2)
            Man_enter_rules
            ;;
        3) handle_ip_traffic ;;
        4) service_handling ;;
        5) break ;;
        *) echo -e "${RED} INVALID COMMAND" ;;
        esac
    done
}

del_mand() {
    clear
    while [ true ]; do
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_YELLOW}Rule Mangement${RESET}"
        for option in "${delop[@]}"; do
            echo -e "${BRIGHT_WHITE} ${option}${RESET}"
        done

        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        read choice
        case $choice in
        1) delete_rule_line ;;
        2) delete_rule_spec ;;
        3) Man_delete ;;
        4) break ;;
        *) echo -e "${RED} INVALID COMMAND ${RESET}" ;;
        esac
    done
}
