#!/bin/bash

source "lib/basic.sh"
source "lib/rule_handling.sh"
source "lib/colors.sh"
source "lib/define.sh"
source "lib/rule_management.sh"
# Default policies
DEFAULT_POLICY="DROP"
LOOPBACK_POLICY="ACCEPT"

interface=""

see_all_interfaces
while [ true ]; do
    read -p "Enter The WAN interface name : " interface
    if ip link show "$interface" >/dev/null 2>&1; then
        # echo -e "${BRIGHT_WHITE} WAN DEv s"
        echo -e "${GREEN}Selected WAN interface : $interface ${RESET}"
        break
    else
        echo -e "${RED} WRONG interface selected : $interface ${RESET}"
    fi
done

# Flush iptables rules
sudo iptables -F
sudo iptables -t nat -F

# wan_dev = $(select_dev)
basic $interface
handle_ip_traffic
handle_services
clear

while [ true ]; do
    # clear
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "${BRIGHT_YELLOW}Menu${RESET}"
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    for option in "${options[@]}"; do
        echo -e "${BRIGHT_WHITE} ${option}${RESET}"
    done
    echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
    echo -e "Enter your menu choice ${BRIGHT_MAGENTA}[1-10]${RESET}: "
    read choice
    case $choice in
    1)
        echo "You have selected the option 1"
        rule_mand
        ;;
    2)
        echo "You have selected the option 2"
        port_forwarding $interface
        ;;
    3)
        echo "You have selected the option 3"
        create_network_segments
        ;;
    4)
        echo "You have selected the option 4"
        see_all_interfaces
        ;;
    5)
        echo "You have selected the option 5"
        View_rules
        ;;
    6)
        echo "You have selected the option 6"
        #
        del_mand
        ;;
    7)
        echo "You have selected the option 7"
        rule_modify
        ;;
    8)
        echo "You have selected the option 8"
        echo -e "${CYAN} SAVING RULES .... > rules.v4${RESET}"
        sudo iptables-save >rules.v4
        sudo iptables-save >/etc/iptables/rules.v4
        sudo systemctl restart iptables
        echo -e "${CYAN}Done..${RESET}"
        ;;
    9)
        echo "You have selected the option 9"
        echo -e "${BRIGHT_BLUE}Restart iptables ${RESET}"
        sudo systemctl restart iptables
        ;;
    10)
        echo "Quitting ..."
        # exit
        break
        ;;
    11)
        clear
        ;;
    *) echo "invalid option" ;;
    esac
    # clear
done

echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
sudo iptables -L -v -n
echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"
sudo iptables -t nat -L
echo -e "${BRIGHT_MAGENTA}********************************************************${RESET}"

sudo iptables -F
sudo iptables -t nat -F

echo -e "${CYAN}Flusing all the Rules....!"

# iptables -A INPUT -i lo -j $LOOPBACK_POLICY
