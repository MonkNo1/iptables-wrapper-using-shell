#!/bin/bash

source "lib/define.sh"
source "lib/rule_handling.sh"

rule_mand() {
    clear
    while [ true ]; do
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_YELLOW}Rule Mangement${RESET}"
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_WHITE} ${ruleop1}${RESET}"
        echo -e "${BRIGHT_WHITE} ${ruleop2}${RESET}"
        echo -e "${BRIGHT_WHITE} ${ruleop3}${RESET}"
        echo -e "${BRIGHT_WHITE} ${ruleop4}${RESET}"
        echo -e "${BRIGHT_WHITE} ${ruleop5}${RESET}"

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
        4) handle_services ;;
        5) break ;;
        *) echo -e "${RED} INVALID COMMAND" ;;
        esac
    done
}
