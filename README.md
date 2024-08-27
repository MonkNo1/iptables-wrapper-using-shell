# ** IPTables-wrapper-sh**
# IPTables Shell Script Wrapper

This shell script provides an interactive, menu-based terminal user interface (TUI) for managing IPTables. Designed to be simple, user-friendly, and secure, it allows users to manage firewall rules, port forwarding, and network segments efficiently.

## Features

- **Interactive Menu-based TUI**: Navigate and manage IPTables through an intuitive menu system.
- **Rule Management**: Load, add, modify, or delete IPTables rules effortlessly.
- **Load Rules from File or URL**: Import rules from a file or directly from a URL.
- **Port Forwarding**: Easily configure and manage port forwarding.
- **Network Segments**: Create and manage network segments with ease.
- **View and Save Rules**: View current IPTables rules and save them for future use.
- **Flush and Import Rules**: Options to flush existing rules and import new ones.
- **Restart IPTables**: Restart IPTables directly from the interface.
- **Security**: Command injection prevention is implemented for custom rule entry, ensuring secure operation.
- **Easy Navigation**: Options to clear the screen and quit ensure a smooth user experience.


## Installation


1. **Install Required Packages**:
    Ensure you have `iptables` and `iptables-persistent` installed on your system. These packages are necessary for managing and saving IPTables rules.

    For Debian/Ubuntu-based systems, use the following commands:

    ```bash
    sudo apt update
    sudo apt install iptables iptables-persistent
    ```

    For Red Hat/CentOS-based systems, use:

    ```bash
    sudo yum install iptables iptables-services
    ```


2. **Clone the Repository**:
    ```bash
    git clone https://github.com/MonkNo1/iptables-wrapper-sh.git
    cd iptables-wrapper-sh
    ```

3. **Make the Script Executable**:
    ```bash
    chmod +x ipt.sh
    ```

4. **Run the Script**:
    ```bash
    ./ipt.sh
    ```

## Usage

When you run the script, you will be presented with a menu of options:

### Main Menu Options

```plaintext
1. Rule Management
2. Port Forwarding
3. Create Network Segment(Comming Soon!!)
4. See Available Interfaces
5. View Rules
6. Delete Rules
7. Modify Rules
8. Save IPTables Rules
9. Restart IPTables
10. Quit
11. Clear Screen
```

### Rule Management Submenu

```
1. Load old Rules
2. Enter Rules Manually
3. Add IP Rules
4. Add Service Rule
5. Back
```

- **Load old Rules**: Load previously saved IPTables rules.
- **Enter Rules Manually**: Manually input new IPTables rules.
- **Add IP Rules**: Add rules specific to IP addresses.
- **Add Service Rule**: Add rules specific to services.
- **Back**: Return to the main menu.

### Delete Rules Submenu

```
1. Delete a Rule By Line
2. Delete a Rule By Specifications
3. Delete a Rule Manually (CUSTOM Rule)
4. Back
```

- **Delete a Rule By Line**: Remove a rule based on its line number.
- **Delete a Rule By Specifications**: Remove a rule based on specific criteria.
- **Delete a Rule Manually (CUSTOM Rule)**: Remove a rule by specifying a custom rule.
- **Back**: Return to the main menu.

### Example Workflow

1. **Rule Management**:
   - Select option `1` from the main menu to access the Rule Management submenu.
   - In the Rule Management submenu:
     - **Load old Rules**: Choose this to load previously saved IPTables rules.
     - **Enter Rules Manually**: Choose this to manually input new IPTables rules. This option allows you to add rules directly into IPTables.
     - **Add IP Rules**: Use this option to add rules specific to IP addresses. This allows for detailed control over traffic based on IP address.
     - **Add Service Rule**: Select this to add rules based on specific services or ports.
     - **Back**: Return to the main menu if you don't want to make changes.

2. **Delete Rules**:
   - Choose option `6` from the main menu to access the Delete Rules submenu.
   - In the Delete Rules submenu:
     - **Delete a Rule By Line**: Remove a rule by specifying its line number in IPTables.
     - **Delete a Rule By Specifications**: Remove a rule based on specific criteria, such as source or destination IP.
     - **Delete a Rule Manually (CUSTOM Rule)**: Remove a rule by manually entering a custom rule to delete.
     - **Back**: Return to the main menu if you don't want to delete any rules.

3. **Save and Restart**:
   - After making changes to the rules:
     - Use option `8` from the main menu to save your IPTables rules. This ensures your changes persist after a reboot.
     - Use option `9` to restart IPTables. This applies the changes you’ve made and ensures that IPTables is using the updated rules.

By following these steps, you can effectively manage, delete, save, and apply IPTables rules using the script’s interactive menu system.

## Security

The script is designed with security in mind, incorporating the following features:

- **Command Injection Prevention**: Custom rule entry is protected against command injection attacks. Input is sanitized to ensure that only valid commands are executed, reducing the risk of unauthorized command execution.

- **Input Validation**: All inputs, including file paths and URLs, are validated to prevent the execution of harmful commands and to ensure that only legitimate operations are performed.

- **Safe File Handling**: When loading rules from files or URLs, the script verifies file integrity and source authenticity to avoid security risks associated with untrusted content.

- **Minimal Privileges**: The script operates with minimal privileges necessary to perform its tasks, reducing the potential impact of any security vulnerabilities.

By adhering to these practices, the script aims to provide a secure environment for managing IPTables rules and operations.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

The MIT License is a permissive license that allows for reuse with minimal restrictions. It provides the freedom to use, modify, and distribute the code, provided that the original license and copyright notice are included. For more information, please refer to the full text of the license included in the LICENSE file.
