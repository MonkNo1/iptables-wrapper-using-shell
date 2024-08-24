#!/bin/bash

source "./define"
source "./rule_handling"

rule_mand() {
    clear
    while [ true ]; do
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_YELLOW}Rule Mangement${RESET}"
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        echo -e "${BRIGHT_WHITE} ${option1}${RESET}"
        echo -e "${BRIGHT_WHITE} ${option2}${RESET}"
        echo -e "${BRIGHT_WHITE} ${option3}${RESET}"
        echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
        read choice
        case $choice in
        1)
            load_rules
            break
            ;;
        # 2) ;;
        *) echo -e "${RED} INVALID COMMAND" ;;
        esac
    done
}
