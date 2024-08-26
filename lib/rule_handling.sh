#!/bin/bash

source "lib/colors.sh"

see_all_interfaces() {
    echo "Avilable Network interfaces : "
    ifconfig -a | sed 's/:$//' | awk '/^[a-zA-Z]/ { iface=$1 } /inet / { print "* " iface ": " $2 }'
}
# Optionally, ask user if they want to handle traffic from a specific IP
handle_ip_traffic() {
    echo -e "${YELLOW}Handle traffic from a specific IP: ${RESET}"
    read -p "Do you want to allow any specific IP ? (y/n): " allow_specific_ip
    if [ "$allow_specific_ip" == "y" ] || [ "$allow_specific_ip" == "Y" ]; then
        while [ true ]; do
            read -p "Enter the IP address: " specific_ip
            read -p "Do you want to accept or drop traffic from this IP? (ACCEPT/DROP): " specific_ip_action
            read -p "Protocol of service : (tcp/udp): " sproto
            if [ "$sproto" == "ALL" ] || [ "$sproto" == "all" ]; then
                protocol="-p all"
            else
                protocol="-p $sproto"
            fi
            echo "sudo iptables -A INPUT $protocol -s $specific_ip -j ${specific_ip_action^^}"
            sudo iptables -A INPUT $protocol -s $specific_ip -j ${specific_ip_action^^}
            sudo iptables -A OUTPUT $protocol -d "$specific_ip" -j ${specific_ip_action^^}

            echo -e "${GREEN}Rules added $sproto/$specific_ip => ${specific_ip_action^^} ${RESET}"
            read -p "Do you want to add Another IP (y/n): " op
            if [[ "$op" == "n" || "$op" == "N" ]]; then
                break
            fi
        done
    fi
}

handle_services() {
    # Ask user for connection types and ports to allow
    echo -e "${YELLOW}Specify connection types:${RESET}"
    read -p "Do you want to allow any specific Service  ? (y/n): " allow_specific_Ser
    if [ "$allow_specific_Ser" == "y" ] || [ "$allow_specific_Ser" == "Y" ]; then
        while [ true ]; do
            read -p "TCP/UDP/ALL: " protocol_input

            # Process protocol and port inputs
            if [ "$protocol_input" == "ALL" ]; then
                protocol="-p all"
            else
                protocol="-p $protocol_input"
            fi

            echo -e "${YELLOW}Specify ports or port ranges to allow: ${RESET}"
            read -p "Port (e.g., 80) or port range (e.g., 22-80): " port_input

            # Process port inputs
            IFS='-' read -ra port_range <<<"$port_input"
            if [ ${#port_range[@]} -eq 1 ]; then
                port="-m multiport --dports ${port_range[0]}"
            else
                port="-m multiport --dports ${port_range[0]}:${port_range[1]}"
            fi

            read -p "Do you want to accept or drop traffic ? (ACCEPT/DROP) : " action

            sudo iptables -A INPUT $protocol $port -j ${action^^}

            echo "${GREEN}Rules added $proto/$port_input => ${action^^} ${RESET} "
            read -p "Do you want to add Another service (y/n): " op
            if [[ "$op" == "n" || "$op" == "N" ]]; then
                break
            fi
        done
    fi
}

port_forwarding() {

    local EXTERNAL_INTERFACE="$1"
    read -p "Enter the Internal webserver Ip (xx.xx.xx.xx): " INTERNAL_SERVER_IP
    read -p "Enter the Protocol the service going to Use (tcp/udp/all): " proto
    read -p "Enter the Port of internal webserver (8080): " port
    read -p "Enter the NAT main server port(8080)" N_PORT

    sudo iptables -t nat -A PREROUTING -p $proto --dport $N_PORT -i $EXTERNAL_INTERFACE -j DNAT --to-destination $INTERNAL_SERVER_IP:$port
    sudo iptables -t nat -A POSTROUTING -p $proto -d $INTERNAL_SERVER_IP --dport $port -j MASQUERADE
    sudo iptables -A FORWARD -p $proto -d $INTERNAL_SERVER_IP --dport $port -j ACCEPT

    echo -e "${GREEN}Rule Added $proto/$INTERNAL_SERVER_IP/$port ${RESET}"
}

create_network_segments() {

    read -p "Network Segemnt Type (WAN/LAN/DMZ) : " Action

    see_all_interfaces

    while [ true ]; do
        read -p "Enter the Network interface need to made into $Action : " MAN_INTERFACE
        if ip link show "$MAN_INTERFACE" >/dev/null 2>&1; then
            echo -e "${GREEN}Selected WAN interface : $MAN_INTERFACE ${RESET}"
            break
        else
            echo -e "${RED} WRONG interface selected : $MAN_INTERFACE ${RESET}"
        fi
    done

    case $Action in
    "LAN")
        # LAN rules (allow all outgoing and incoming)
        sudo iptables -A INPUT -i $MAN_INTERFACE -j ACCEPT
        sudo iptables -A OUTPUT -o $MAN_INTERFACE -j ACCEPT
        ;;
    "WAN")
        # WAN rules (allow all outgoing, restrict incoming)
        sudo iptables -A OUTPUT -o $MAN_INTERFACE -j ACCEPT
        sudo iptables -A INPUT -i $MAN_INTERFACE -m state --state ESTABLISHED,RELATED -j ACCEPT
        ;;
    "DMZ")
        # DMZ rules (allow HTTP, deny all else)
        sudo iptables -A INPUT -i $MAN_INTERFACE -p tcp --d
        #DMZ part ===>
        ;;
    *)
        echo -e "${RED} INVALID INPUT ${RESET}"
        ;;
    esac
}

View_rules() {
    if [[ $# -eq 1 ]]; then
        table="$1"
    else
        read -p "Enter Rule Table Name(Filter/NAT/MANGLE/RAW/SECURITY/ALL) : " table

    fi
    case ${table^^} in
    "FILTER")
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        sudo iptables --line-number -vL -t filter
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    "NAT")
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        sudo iptables --line-number -vL -t nat
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    "MANGLE")
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        sudo iptables --line-number -vL -t mangle
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    "RAW")
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        sudo iptables --line-number -vL -t raw
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    "SECURITY")
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        sudo iptables --line-number -vL -t security
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    "ALL")
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        sudo iptables --line-number -vL -t filter
        sudo iptables --line-number -vL -t nat
        sudo iptables --line-number -vL -t mangle
        sudo iptables --line-number -vL -t raw
        sudo iptables --line-number -vL -t security
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    *)
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        echo -e "${BRIGHT_RED}INVALID COMMAND ${RESET}"
        echo -e "${BRIGHT_YELLOW}***************************************************${RESET}"
        ;;
    esac
}

load_rules() {
    echo -e "do you want load rules from URL : " churl
    if [ $churl=="Y" ] || [ $churl=="y" ]; then
        read -p "URL : " url
        curl "${url}" -o urlrule.v4
        sudo iptables-restore <urlrule.v4
        sudo rm urlrule.v4
        return
    fi
    read -p "Enter the rule File location : " loca
    if [ -e $loca ]; then
        echo -e "$(realpath "$loca")"
        read -p "Check the path of the File (y/n): " ch
        if [ $ch=="Y" ] || [ $ch=="y" ]; then
            # sudo iptables-restore <$loca
            read -p "Do you want to flush and load rules (y/n) : " fl
            if [ $fl=="Y" ] || [ $fl=="y" ]; then
                sudo iptables -F
                sudo iptables-restore <$loca
            else
                sudo iptables-restore <$loca
            fi

        else
            break
        fi
    else
        echo -e "${RED} INVALID LOCATION ${RESET}"
    fi
}

Man_enter_rules() {
    echo -e "${BRIGHT_BLUE}Enter the Full Rule${RESET}"
    read manrul
    if echo "$manrul" | grep -Eq '[;&|<>`$()]'; then
        echo -e "${RED}Invalid input detected. Please enter a valid iptables rule.${RESET}"
    else
        if sh -c "$manrul" 2>&1 >/dev/null; then
            echo "Rule Added"
        else
            echo "Error"
        fi
    fi
}

delete_rule_line() {
    read -p "Enter the TABLE you want to delete (Filter/NAT/MANGLE/RAW/SECURITY/ALL): " Table
    View_rules "$Table"
    read -p "Enter Chain name to delete (eg: INPUT/OUTPUT): " chainn
    read -p "Enter line number to delete: " linenum
    Table=$(echo "$Table" | tr '[:upper:]' '[:lower:]')
    rule="sudo iptables -t ${Table} -D ${chainn^^} ${linenum}"
    echo "$rule"
    if sh -c "$rule" >/dev/null 2>&1; then
        echo -e "${GREEN}Deleted successfully.${RESET}"
    else
        echo -e "${RED}Error: Rule not deleted."
    fi
}

delete_rule_spec() {
    read -p "Enter the TABLE (Filter/NAT/MANGLE/RAW/SECURITY): " table
    View_rules "$table"
    read -p "Enter Chain name (e.g., INPUT/OUTPUT/FORWARD): " chain
    read -p "Enter Protocol (e.g., tcp/udp/icmp): " protocol
    read -p "Enter Source IP (leave blank for any): " src_ip
    read -p "Enter Destination IP (leave blank for any): " dest_ip
    read -p "Enter Source Port (leave blank for any): " src_port
    read -p "Enter Destination Port (leave blank for any): " dest_port
    read -p "Enter Action u need to delete(ACCEPT/DROP/DENY): " action

    table=$(echo "$table" | tr '[:upper:]' '[:lower:]')
    chain=$(echo "$chain" | tr '[:lower:]' '[:upper:]')

    rule="sudo iptables -t $table -D $chain"

    # Add protocol
    if [ -n "$protocol" ]; then
        rule="$rule -p $protocol"
    fi

    # Add source IP
    if [ -n "$src_ip" ]; then
        rule="$rule --source $src_ip"
    fi

    # Add destination IP
    if [ -n "$dest_ip" ]; then
        rule="$rule -d $dest_ip"
    fi

    # Add source port
    if [ -n "$src_port" ]; then
        rule="$rule --sport $src_port"
    fi

    # Add destination port
    if [ -n "$dest_port" ]; then
        rule="$rule --dport $dest_port"
    fi

    rule="$rule -j ${action^^}"
    echo "Executing: $rule"
    if sh -c "$rule" >/dev/null 2>&1; then
        echo -e "${GREEN}Rule deleted successfully.${RESET}"
    else
        echo -e "${RED}Error: Rule not deleted. Ensure the rule exists and the specifications are correct.${RESET}"
    fi
}

Man_delete() {
    echo -e "${BRIGHT_BLUE}Enter the Custom RULE to Delete ${RESET}"
    read manrul
    if echo "$manrul" | grep -Eq '[;&|<>`$()]'; then
        echo -e "${RED}Invalid input detected. Please enter a valid iptables rule.${RESET}"
    else
        if sh -c "$manrul" 2>&1 >/dev/null; then
            echo "Rule Deleted"
        else
            echo "Error"
        fi
    fi
}

rule_modify() {
    read -p "Enter the TABLE you want to modfiy (Filter/NAT/MANGLE/RAW/SECURITY/ALL): " Table
    View_rules "$Table"
    read -p "Enter Chain name to modify (eg: INPUT/OUTPUT): " chainn
    read -p "Enter line number to modify: " linenum
    Table=$(echo "$Table" | tr '[:upper:]' '[:lower:]')
    read -p "Enter the modification should be done : " mod
    rule="sudo iptables -t ${Table} -R ${chainn^^} ${linenum} ${mod}"
    echo "$rule"
    if sh -c "$rule" >/dev/null 2>&1; then
        echo -e "${GREEN}modified successfully.${RESET}"
    else
        echo -e "${RED}Error: Rule not modified."
    fi
}
