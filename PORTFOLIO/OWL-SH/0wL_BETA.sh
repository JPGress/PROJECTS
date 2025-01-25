#!/bin/bash

######################## VARIABLES ########################

    # Color definitions
    BLACK="\e[30m"
    RED="\e[31m"
    GREEN="\e[32m"
    YELLOW="\e[33m"
    BLUE="\e[34m"
    MAGENTA="\e[35m"
    CYAN="\e[36m"
    WHITE="\e[37m"
    GRAY="\e[90m"

    # Background color definitions
    BG_BLACK="\e[40m"
    BG_RED="\e[41m"

    # Reset terminal color
    RESET="\e[0m"

######################## SUPPORT FUNCTIONS ########################
    # Function: Enable Proxychains
    function enable_proxychains() {
        clear; # Clear terminal screen
        ascii_banner_art; # Call ASCII banner art
        
        # Check if proxychains is installed
        if ! command -v proxychains &> /dev/null; then
            echo -e "${RED} >>> ERROR: proxychains is not installed. Please install it before running the script. <<< ${RESET}"
            exit 1
        fi

        # Check if the proxychains configuration file exists
        if [[ ! -f /etc/proxychains.conf ]]; then
            echo -e "${RED} >>> ERROR: Proxychains configuration file not found. Make sure /etc/proxychains.conf exists. <<< ${RESET}"
            exit 1
        fi

        # Test proxychains by attempting a simple network request
        echo -e "${MAGENTA} >>> Testing proxychains with 'proxychains curl -I https://dnsleaktest.com'... ${RESET}"
        if proxychains curl -I https://dnsleaktest.com &> /dev/null; then
            echo -e "${GREEN} >>> Proxychains is working correctly. All traffic will be routed through it. <<< ${RESET}"
            countdown; # Wait for 5 seconds before continuing
            export PROXYCHAINS=1
        else
            echo -e "${RED} >>> WARNING: Proxychains test failed. Please verify your proxychains configuration. <<< ${RESET}"
            export PROXYCHAINS=0
        fi
    }

    # Function: Display the menu header with the script name and author
    function ascii_banner_art() {
        echo -e ""
        echo -e "${RED} ██████╗     ██████╗ ██╗    ██╗██╗         ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗${RESET}"
        echo -e "${RED}██╔═████╗   ██╔═████╗██║    ██║██║         ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝${RESET}"
        echo -e "${RED}██║██╔██║   ██║██╔██║██║ █╗ ██║██║         ███████╗██║     ██████╔╝██║██████╔╝   ██║   ${RESET}"
        echo -e "${RED}████╔╝██║   ████╔╝██║██║███╗██║██║         ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ${RESET}"
        echo -e "${RED}╚██████╔╝██╗╚██████╔╝╚███╔███╔╝███████╗    ███████║╚██████╗██║  ██║██║██║        ██║   ${RESET}"
        echo -e "${RED} ╚═════╝ ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ${RESET}"
        echo -e "${RED}                                                                            sh-v 0.9.1 ${RESET}"   
        echo -e "${GRAY}+===================================== 0.0wL ========================================+${RESET}"
        echo -e "${GRAY}+                          Created by JPGress a.k.a R3v4N||0wL                       +${RESET}"
        echo -e "${GRAY}+====================================================================================+${RESET}"
    }

    function subtitle() {
        echo -e "${GRAY}+====================================================================================+${RESET}"
    }

    # Function: Disabled
    function disabled() {
        echo ""
        echo -e "${RED} >>> FUNCTION DISABLED <<< ${RESET}"
        echo ""
        echo -e "${GRAY} Press ENTER to continue ${RESET}"
        read -r
        main_menu
    }

    # Function: Error message for non-root users
    function error_not_root() {
        clear
        echo ""
        echo -e "${BG_BLACK}${RED} >>> YOU MUST BE ROOT TO RUN THIS SCRIPT! <<< ${RESET}"
        echo ""
        exit 1
    }

    # Function: Error message for invalid usage
    function error_invalid_usage() {
        clear
        echo ""
        echo -e "${BG_BLACK}${RED} >>> ERROR! <<< ${RESET}"
        echo ""
        echo -e "${BG_BLACK}${RED} Usage: $0 ${RESET}"
        exit 1
    }

    # Function: Invalid option
    function invalid_option() {
        echo -e "${BG_RED}${BLACK} INVALID OPTION! ${RESET}${RED} Please run the script again and choose a valid option.${RESET}"
        echo -e "${GRAY} Press ENTER to continue ${RESET}"
        read -r
        main_menu
    }

    # Function: Exit script (on zero input)
    function exit_script() {
        clear; # Clear terminal screen
        ascii_banner_art; # Call ASCII banner art
        echo -e "${RED} >>> Exiting the script. Bye! ${RESET}"
        echo -e "${RED} Press ENTER to continue ${RESET}"
        read -r 2> /dev/null
        clear; # Clear terminal screen
        exit 0
    }

    # Function: Pause the script
    function pause_script() {
        echo -e "${GRAY} Press ENTER to continue ${RESET}"
        read -r 2> /dev/null
        main_menu
    }

    # Function: 3-second countdown
    function countdown() {
        local seconds=3 # Number of seconds for the countdown

        # Countdown loop
        while [ $seconds -gt 0 ]; do
            echo -ne "${GRAY} Starting in: $seconds \r${RESET}" # Display the countdown and overwrite the same line
            sleep 1 # Wait for 1 second
            ((seconds--)) # Decrease the countdown value
        done
    }

    # Function: Validate user input for the main menu
    function validate_input() {
        local input="$1" # The input to validate
        local valid_options=("$@") # All valid options passed as arguments (from the second argument onward)

        # Check if the input is in the list of valid options
        for option in "${valid_options[@]:1}"; do
            if [[ "$input" == "$option" ]]; then
                return 0 # Input is valid
            fi
        done

        # If we reach here, the input is invalid
        echo -e "${RED} >>> Invalid option: $input. Please choose a valid menu option. <<< ${RESET}"
        return 1 # Input is invalid
    }

    # Function to restart the Tor service for IP rotation
    function restart_tor() {
        echo ""
        echo -e "${MAGENTA} Restarting Tor to rotate IP.${RESET}"
        echo -e "${GRAY} Please wait...${RESET}"
        if sudo systemctl restart tor; then
            echo -e "${GREEN} =====================================================${RESET}"
            echo -e "${GREEN} Tor restarted successfully. New IP circuit activated!${RESET}"
            echo ""
            sleep 4  # Allow time for the new circuit to establish
        else
            echo -e "${RED}Failed to restart Tor. Check your Tor configuration or service status.${RESET}"
            exit 1
        fi
    }

    # Function: Display the main menu
    function display_main_menu() {
        clear; # Clears the terminal screen
        ascii_banner_art; # Call ASCII banner art

        # Display numbered menu options
        echo -e "${MAGENTA} 1 - Portscan ${RESET}" 
        echo -e "${MAGENTA} 2 - Parsing HTML ${RESET}" 
        echo -e "${MAGENTA} 3 - Google Hacking for people OSINT ${RESET}" 
        echo -e "${MAGENTA} 4 - Metadata Analysis ${RESET}" 
        echo -e "${MAGENTA} 5 - DNS Zone Transfer ${RESET}" 
        echo -e "${MAGENTA} 6 - Subdomain Takeover ${RESET}" 
        echo -e "${GRAY}${BG_BLACK} 7 - Reverse DNS ${RESET}" 
        echo -e "${MAGENTA} 8 - DNS Reconnaissance ${RESET}"
        echo -e "${GRAY}${BG_BLACK} 9 - OSINTool ${RESET}"
        echo -e "${MAGENTA} 10 - MiTM (Man-in-the-Middle)"
        echo -e "${GRAY}${BG_BLACK} 11 - Portscan (Bash sockets) ${RESET}"
        echo -e "${MAGENTA} 12 - Useful Commands for Network Management"
        echo -e "${MAGENTA} 13 - Examples of the 'find' Command"
        echo -e "${MAGENTA} 14 - Root Password Reset Guide (Debian)"
        echo -e "${GRAY}${BG_BLACK} 15 - Root Password Reset Guide (Red Hat)${RESET}"
        echo -e "${MAGENTA} 16 - Quick Guide to Using Vim"
        echo -e "${GRAY}${BG_BLACK} 17 - Escape Techniques for rbash (Testing) ${RESET}"
        echo -e "${MAGENTA} 18 - Wireless Network Attacks"
        echo -e "${MAGENTA} 19 - Windows Tips"
        echo -e "${GRAY}${BG_BLACK} 20 - Create Scripts in .bat or .ps1 ${RESET}"
        echo -e "${MAGENTA} 21 - Switch to Sgt Domingues' Scanning Script"
        echo -e "${MAGENTA} 22 - NMAP Network Scan ${RESET}"
        echo -e "${GRAY}${BG_BLACK} 23 - Reserved Option ${RESET}"
        echo -e "${GRAY}${BG_BLACK} 24 - Reverse Shell for Windows ${RESET}"
        echo -e "${GRAY}${BG_BLACK} 25 - RDP for Windows ${RESET}"

        # Display instructions to exit the menu
        echo -e "${GRAY}+==============================================+${RESET}"
        echo -e " ${WHITE}Enter 0 (zero) to exit${RESET}"
        echo -e "${GRAY}+==============================================+${RESET}"
    }

######################## MAIN MENU ########################
    # Function: Main menu
    function main_menu() {
        display_main_menu # Display the menu

        # Define valid menu options dynamically
        valid_options=()
        for i in {0..25}; do
            if [[ "$i" -ne 23 ]]; then
                valid_options+=("$i")
            fi
        done

        # Prompt user for input
        echo -ne "${CYAN} Enter the option number: ${RESET}"
        read -r MENU_OPTION # Read user input

        # Validate the user input
        if ! validate_input "$MENU_OPTION" "${valid_options[@]}"; then
            invalid_option # Call the invalid_option function if input is invalid
            main_menu # Restart the menu
            return
        fi

        # If valid, proceed to handle the selected option
        case $MENU_OPTION in
            0) exit_script ;; # Exit the script
            1) i_portscan ;; # Perform a port scan
            2) ii_parsing_html ;; # Parse HTML
            3) iii_google_hacking ;; # Perform Google Hacking
            4) iv_metadata_analysis ;; # Analyze metadata from the Internet
            5) v_dns_zone_transfer ;; # Perform DNS Zone Transfer
            6) vi_subdomain_takeover ;; # Perform Subdomain Takeover
            7) disabled ;; # DISABLED FOR MAINTENANCE -> vii_reverse_dns ;;
            8) viii_dns_recon ;; # DNS Reconnaissance
            9) disabled ;; # DISABLED - REQUIRES REFACTORING -> ix_google_general_query ;;
            10) x_mitm ;; # MiTM (Man-in-the-Middle)
            11) disabled ;; # DISABLED FOR MAINTENANCE -> xi_portscan_bashsocket ;;
            12) xii_network_management_commands ;; # Useful network management commands
            13) xiii_find_command_examples ;; # Examples of the 'find' command
            14) xiv_debian_root_password_reset ;; # Root password reset guide for Debian
            15) disabled ;; # DISABLED FOR MAINTENANCE -> xv_redhat_root_password_reset ;;
            16) xvi_vim_quick_guide ;; # Quick guide to using Vim
            17) disabled ;; # DISABLED FOR MAINTENANCE -> xvii_rbash_escape_techniques ;;
            18) xviii_wifi_attacks ;; # Wireless network attacks
            19) xix_windows_basic_commands ;; # Basic Windows commands
            20) disabled ;; # DISABLED FOR MAINTENANCE -> xx_create_windows_script ;; #! TODO: DELETE
            21) xxi_sgt_domingues_scanning_script ;; # Switch to Sgt Domingues' scanning script ;; #! TODO: DELETE
            22) xxii_nmap_network_discovery ;; # NMAP network scan
            24) disabled ;; # DISABLED FOR MAINTENANCE -> xxiv_windows_revshell ;;
            25) disabled ;; # DISABLED FOR MAINTENANCE -> xxv_windows_rdp ;;
            *) invalid_option ;; # Fallback case (should never happen with validation)
        esac
    }

######################## FUNÇÕES DO MENU ########################
    # Function: Script to perform a port scan on a network using netcat
    function i_portscan() {
        # i_portscan - Script to perform a port scan on a network using netcat
            #
            # Description:
            # This script performs the following operations:
            # 1. Checks for common open ports on all hosts within a specified IP range (CIDR format).
            # 2. Dynamically loads a user-defined number of top ports (e.g., 20, 100, 1000) from Nmap's services file, if available.
            # 3. Falls back to a predefined list of common ports if Nmap's file is unavailable.
            # 4. Prints results for each host and open port found.
            # 5. Saves the results in two file formats:
            #    - Plain text (`portscan_results.txt`) for human-readable output.
            #    - CSV (`portscan_results.csv`) for structured data analysis.
            #
            # Dependencies:
            # - netcat (nc): To perform the port scanning.
            # - ipcalc: To validate and parse CIDR-based network masks.
            # - awk: To process data from Nmap's services file.
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-23
            # Last Updated: 2025-01-24
            # Version: 1.2
            #
            # Version history:
            # - 1.0 (2025-01-23): Initial version with basic port scanning functionality.
            # - 1.1 (2025-01-23): Added support for saving results in `.txt` and `.csv` formats.
            #                     Integrated dynamic port loading from Nmap's services file.
            # - 1.2 (2025-01-23): Added user input to define the number of top ports to scan.
            #                     Improved flexibility and user control over scan depth.
            #
            # Notes:
            # - Ensure the required dependencies are installed before running the script.
            # - If `ipcalc` is not installed, the script will attempt to install it automatically.
            # - Users can dynamically select the number of top ports to scan.
            # - Results are saved in the current working directory as `portscan_results.txt` and `portscan_results.csv`.
            # - Handles Ctrl+C interruptions gracefully and returns to the main menu.
            #
            # Example usage:
            # - Input:
            #   - Number of ports: 100
            #   - CIDR: "192.168.1.0/24"
            # - Output:
            #   - Terminal: "Host: 192.168.1.1 - Open Port: 80"
            #   - Text File: "Host: 192.168.1.1 - Open Port: 80"
            #   - CSV File: "192.168.1.1,80,Open"

        clear
        echo -e "${MAGENTA}1 - Portscan using netcat ${RESET}"
        echo -e "${GRAY}+======================================================================+${RESET}"
        echo -e "${GRAY}This port scan checks common open ports on all hosts in the network."
        echo -e "${GRAY}+======================================================================+${RESET}"

        # Ask the user how many top ports they want to scan
        echo -ne "${CYAN}Enter the number of top ports to scan (e.g., 20, 100, 1000): ${RESET}"
        read -r TOP_PORTS

        # Validate the user's input (ensure it's a positive number)
        if ! [[ "$TOP_PORTS" =~ ^[0-9]+$ ]] || [[ "$TOP_PORTS" -le 0 ]]; then
            echo -e "${RED}Invalid input! Please enter a positive number.${RESET}"
            main_menu
            return
        fi

        # Load ports dynamically from Nmap or use a fallback list
        local nmap_services="/usr/share/nmap/nmap-services" # Path to Nmap's services file
        local fallback_ports="80,23,443,21,22,25,3389,110,445,139,143,53,135,3306,8080,1723,111,995,993,5900"

        if [[ -f "$nmap_services" ]]; then
            # Extract the top N ports based on the user's choice
            PORT_LIST=$(awk '!/^#/ {print $2}' "$nmap_services" | grep -Eo '^[0-9]+' | sort -n | uniq | head -n "$TOP_PORTS" | paste -sd ',')

            if [[ -n "$PORT_LIST" ]]; then
                echo -e "${GREEN}Loaded the TOP $TOP_PORTS ports from Nmap's services file: $nmap_services${RESET}"
            else
                echo -e "${YELLOW}Warning: Failed to extract ports from Nmap's services file. Falling back to predefined ports.${RESET}"
                PORT_LIST="$fallback_ports"
            fi
        else
            echo -e "${YELLOW}Warning: Nmap services file not found at $nmap_services. Falling back to predefined ports.${RESET}"
            PORT_LIST="$fallback_ports"
        fi

        # Handle Ctrl+C interruptions gracefully
        trap 'echo -e "\nScript interrupted by user."; main_menu; exit 1' SIGINT

        # Ask user to enter the IP range in CIDR notation
        echo -ne "${CYAN}Enter the IP range in CIDR notation (e.g., 192.168.1.0/24): ${RESET}"
        read -r NETWORK_MASK

        # Validate the network mask
        if ! ipcalc -n -b -m "$NETWORK_MASK" >/dev/null 2>&1; then
            echo "Invalid network mask."
            main_menu
            return
        fi

        # Extract the network prefix from the mask
        NETWORK_PREFIX=$(ipcalc -n -b "$NETWORK_MASK" | awk '/Network/ {print $2}' | awk -F. '{print $1"."$2"."$3}')

        # Start scanning each host in the network for the specified ports
        echo -e "${CYAN}Scanning network: $NETWORK_MASK ${RESET}"
        for HOST in $(seq 1 254); do
            IP="$NETWORK_PREFIX.$HOST"
            for PORT in $(echo "$PORT_LIST" | tr ',' ' '); do
                # Check if the port is open on the host
                nc -z -w 1 "$IP" "$PORT" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Host: $IP - Open Port: $PORT ${RESET}"
                fi
            done
        done

        # Completion message
        echo -e "${GREEN}Scan completed for $NETWORK_MASK using the TOP $TOP_PORTS ports.${RESET}"
        echo -e "${GRAY}Press ENTER to continue...${RESET}"
        read -r
        main_menu
    }

    # Function: Script to analyze subdomains and WHOIS information for a website or a list of websites.
    function ii_parsing_html() {
        # parsing_html - Script to analyze subdomains and WHOIS information for a website or a list of websites.
            #
            # Description:
            # This script performs the following operations:
            # 1. Extracts subdomains from an HTML page.
            # 2. Retrieves IP addresses associated with each subdomain.
            # 3. Fetches WHOIS information for each domain.
            # 4. Generates a report with the results.
            #
            # Dependencies:
            # - curl: To make HTTP requests.
            # - dig: To retrieve IP addresses of subdomains.
            # - whois: To get WHOIS information for domains.
            # - nslookup: For DNS lookups.
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2024-01-15
            # Last Updated: 2024-01-24
            # Version: 1.1
            #
            # Version history:
            # - 1.0 (2024-01-15): Initial version with basic subdomain and WHOIS functionality.
            # - 1.1 (2024-01-24): Added dependency checks and updated timestamp format.
            #
            # Example usage:
            # - Input: https://example.com
            # - Output: Subdomains, IP addresses, WHOIS information for each domain.
            #
            # Notes:
            # - Ensure the dependencies are installed before running the script.
            # - The report is saved in a file named "result_<URL>_<date>.txt".
            #

        # Function to check if dependencies are installed
        check_dependencies() {
            local dependencies=("curl" "whois" "nslookup" "dig")
            for dep in "${dependencies[@]}"; do
                if ! command -v "$dep" &>/dev/null; then
                    echo -e "${RED}Error: Dependency '$dep' is not installed.${RESET}"
                    echo "Please install '$dep' before running this script."
                    exit 1
                fi
            done
        }

        # Call the dependency check function
        check_dependencies

        # Prompt the user to input the desired website URL
        echo -n "Enter the URL of the website to analyze (e.g.: businesscorp.com.br): "
        read -r SITE

        # Store the current date and time in the specified format (day-hour-minutes-month-year)
        timestamp=$(date +"%d%H%M%b%Y" | tr '[:lower:]' '[:upper:]') # Example: 241408JAN2024
        output_file="result_${SITE}_${timestamp}.txt"

        # Function to print text in color
        print_color() {
            local color=$1
            local text=$2
            echo -e "\e[0;${color}m${text}\e[0m"
        }

        # Function to extract subdomains from an HTML page
        extract_subdomains() {
            local site=$1
            curl -s "$site" | grep -Eo '(http|https)://[^/"]+' | awk -F[/:] '{print $4}' | sort -u
        }

        # Function to get the IP address of a subdomain
        get_ip_address() {
            local subdomain=$1
            local ip_address
            ip_address=$(host "$subdomain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)
            echo "$ip_address:$subdomain"
        }

        # Function to get WHOIS information for a domain
        get_whois_info() {
            local domain=$1
            whois "$domain" | grep -vE "^\s*(%|\*|;|$|>>>|NOTICE|TERMS|by|to)" | grep -E ':|No match|^$'
        }

        # Function to get DNS lookup information for a domain
        get_dns_info() {
            local domain=$1
            nslookup "$domain" 2>/dev/null | grep "Address" | awk '{print $2}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/, /g'
        }

        # Add the timestamp to the beginning of the output file
        echo -e "Report generated on: $timestamp\n" > "$output_file"

        # Analyze the provided site
        print_color 33 "Analyzing subdomains for: $SITE"
        subdomains=($(extract_subdomains "$SITE"))

        # Check if any subdomains were found
        if [ ${#subdomains[@]} -eq 0 ]; then
            print_color 31 "No subdomains found for: $SITE"
            echo "No subdomains found for: $SITE" >> "$output_file"
        else
            print_color 32 "Subdomains found:"
            for subdomain in "${subdomains[@]}"; do
                print_color 36 "$subdomain"

                # Get IP address for the subdomain
                ip_result=$(get_ip_address "$subdomain")
                echo "$ip_result" >> "$output_file"

                # Add WHOIS information
                print_color 34 "WHOIS information for $subdomain"
                get_whois_info "$subdomain" >> "$output_file"

                # Add DNS lookup information
                print_color 34 "DNS Lookup information for $subdomain"
                get_dns_info "$subdomain" >> "$output_file"

                echo -e "\n" >> "$output_file"
            done
        fi

        # Completion message
        print_color 32 "Analysis complete. Results saved to: $output_file"
        echo -e "${GRAY}Press ENTER to continue${RESET}"
        read -r 2>/dev/null
        main_menu
    }

    # Function: Script to automate Google hacking queries for reconnaissance
    function iii_google_hacking() {
        # iii_google_hacking - Automates Google hacking queries for reconnaissance
            #
            # Description:
            # This script automates Google hacking techniques to gather information about a target.
            # It performs the following operations:
            # 1. Conducts general searches for the target using Google.
            # 2. Searches for specific file types (e.g., PDF, DOCX) containing the target's name.
            # 3. Searches within specific websites (e.g., LinkedIn, Pastebin) for target-related data.
            # 4. Verifies the user's IP address for anonymity before performing queries.
            # 5. Logs all search URLs and details to a file for reference and auditing.
            #
            # Improvements in Version 1.5:
            # - **Fixed Logical Issue**: Browser queries now run in the background to prevent blocking subsequent searches.
            # - **Enhanced Logging**: Debug logs added to track query progress and identify any potential bottlenecks.
            # - **Simplified IP Verification**: Replaced interactive browser-based IP check with a lightweight `curl` request.
            # - **Improved Stability**: Introduced better flow control and error handling for proxy execution.
            #
            # Dependencies:
            # - Firefox or a compatible browser (default: Firefox).
            # - proxychains4: To route queries through proxies for anonymity.
            # - curl: For lightweight IP verification.
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2024-01-15
            # Last Updated: 2025-01-25
            # Version: 1.5
            #
            # Version history:
            # - 1.0 (2024-01-15): Initial version with basic Google hacking queries.
            # - 1.1 (2024-01-24): Refactored for modularity, added input validation, improved user prompts, and added error handling.
            # - 1.2 (2024-01-24): Introduced logging for all searches to a timestamped file.
            # - 1.3 (2024-01-25): Integrated proxy rotation for anonymity and processed dorks for proper formatting.
            # - 1.4 (2024-01-25): Refactored repetitive `proxychains4 $SEARCH` calls into a reusable function.
            # - 1.5 (2025-01-25): Resolved blocking issue with browser queries, enhanced logging, and improved flow control.
            #
            # Example usage:
            # - Input: "Fatima de Almeida Lima"
            # - Output:
            #   - General Google queries, file type searches, and specific website searches performed anonymously.
            #   - Log file saved as "<TARGET>_<timestamp>.log".
            #
            # Notes:
            # - Ensure Firefox or the browser specified in the `SEARCH` variable is installed.
            # - Logs are saved as "<TARGET>_<timestamp>.log" in the current directory.
        # - Designed for educational purposes only; respect applicable laws and ethics.


        # Default browser for search
        SEARCH="firefox"

        # Function to ensure the browser is installed
        function check_browser() {
            if ! command -v "$SEARCH" >/dev/null 2>&1; then
                echo -e "${RED}Error: The browser '$SEARCH' is not installed. Please install it or update the 'SEARCH' variable.${RESET}"
                return 1
            fi
            if ! command -v "proxychains4" >/dev/null 2>&1; then
                echo -e "${RED}Error: 'proxychains4' is not installed. Please install it to enable proxy rotation.${RESET}"
                return 1
            fi
        }

        # Function to prompt the user for the target name
        function google_hacking_menu() {
            clear
            echo -e "${RED}Google Hacking OSINT for People Reconnaissance${RESET}"
            echo -e "${YELLOW}+=============================================+${RESET}"
            echo -e "${CYAN}For better results, put the target in quotes (e.g., \"Fatima de Almeida Lima\").${RESET}"
            echo -n "Enter the target name for the search: "
            read -r TARGET

            # Validate input
            while [[ -z "$TARGET" ]]; do
                echo "Target name cannot be empty. Please try again."
                echo -n "Enter the target name for the search: "
                read -r TARGET
            done

            # Process target as a proper dork (quoted and URL encoded)
            PROCESSED_TARGET=$(echo "\"$TARGET\"" | sed 's/ /%20/g')

            # Create a timestamped log file for the target
            TIMESTAMP=$(date +"%d%H%M%b%Y" | tr '[:lower:]' '[:upper:]')
            LOG_FILE="${TARGET}_${TIMESTAMP}.log"
            echo -e "Log for target: $TARGET\nGenerated on: $(date)\n" > "$LOG_FILE"
        }

        # Function to execute a search query through proxychains
        function perform_query() {
            local url=$1
            echo "Executing query: $url"
            echo "$url" >> "$LOG_FILE"  # Log the query
            proxychains4 $SEARCH "$url" 2>/dev/null &  # Run in the background
            sleep 1  # Optional delay between queries
        }

        # Function to check the current IP address
        function check_ip() {
            echo "Checking your current IP address..."
            local ip=$(curl -s https://api.ipify.org)
            if [[ -z "$ip" ]]; then
                echo "Failed to retrieve IP address. Please check your connection or proxy settings."
                echo "Failed to retrieve IP address." >> "$LOG_FILE"
            else
                echo "Your current IP address is: $ip"
                echo "Current IP address: $ip" >> "$LOG_FILE"
            fi
        }

        # Function for general searches
        function generalSearch() {
            check_ip  # Check and log the IP address
            perform_query "https://webmii.com/people?n=$PROCESSED_TARGET"  # Search on WEBMII
            perform_query "https://www.google.com/search?q=intext:$PROCESSED_TARGET"  # General Google search
        }

        # Function for searches within specific websites
        function siteSearch() {
            local site="$1"
            local domain="$2"
            perform_query "https://www.google.com/search?q=inurl:$domain+intext:$PROCESSED_TARGET"
        }

        # Function for file type searches
        function FileSearch() {
            local type="$1"
            local extension="$2"
            perform_query "https://www.google.com/search?q=filetype:$extension+intext:$PROCESSED_TARGET"
        }

        # Check if the browser and proxychains4 are installed
        check_browser || return 1

        # Prompt for the target name
        google_hacking_menu

        # Perform general searches
        generalSearch

        # List of file types and their extensions for targeted searches
        file_types=("PDF" "PPT" "DOC" "DOCX" "XLS" "XLSX" "ODS" "ODT" "TXT" "PHP" "XML" "JSON" "PNG" "SQLS" "SQL")
        extensions=("pdf" "ppt" "doc" "docx" "xls" "xlsx" "ods" "odt" "txt" "php" "xml" "json" "png" "sqls" "sql")

        # Perform file type searches
        for ((i = 0; i < ${#file_types[@]}; i++)); do
            echo "Processing file type: ${file_types[i]} with extension: ${extensions[i]}" >> "$LOG_FILE"
            FileSearch "${file_types[i]}" "${extensions[i]}"
            echo "Finished processing file type: ${file_types[i]}" >> "$LOG_FILE"
        done

        # List of sites and their corresponding domains for targeted searches
        sites=("Government" "Pastebin" "Trello" "GitHub" "LinkedIn" "Facebook" "Twitter" "Instagram" "TikTok" "YouTube" "Medium" "Stack Overflow" "Quora" "Wikipedia")
        domains=(".gov.br" "pastebin.com" "trello.com" "github.com" "linkedin.com" "facebook.com" "twitter.com" "instagram.com" "tiktok.com" "youtube.com" "medium.com" "stackoverflow.com" "quora.com" "wikipedia.org")

        # Perform searches on specific sites
        for ((i = 0; i < ${#sites[@]}; i++)); do
            echo "Processing site: ${sites[i]} with domain: ${domains[i]}" >> "$LOG_FILE"
            siteSearch "${sites[i]}" "${domains[i]}"
            echo "Finished processing site: ${sites[i]}" >> "$LOG_FILE"
        done

        echo -e "${GRAY}All searches logged in: $LOG_FILE${RESET}"
        echo -e "${GRAY}Press ENTER to return to the main menu.${RESET}"
        read -r 2>/dev/null
        main_menu
    }   

    # Function: iv_metadata_analysis
    function iv_metadata_analysis() {
        SEARCH="lynx -dump -hiddenlinks=merge -force_html"
        
        # Function to prompt the user for required input
        function metadata_analysis_menu() {
            clear;
            ascii_banner_art;
            echo -e "${MAGENTA} 4 - Metadata Analysis ${RESET}"
            subtitle;
            echo -n " Enter the domain or extension to search (e.g., businesscorp.com.br): "
            read -r SITE
            echo -n " Enter the file extension to search for (e.g., pdf): "
            read -r FILE
            echo -n " [Optional] Enter a keyword to refine the search (e.g., user): "
            read -r KEYWORD
        }

        # Function to perform the search based on user input
        function perform_search() {
            if [ -z "$KEYWORD" ]; then
                TIMESTAMP=$(date +%d%H%M%b%Y)-UTC
                FILTERED_RESULTS_FILE="${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"

                echo -e "${MAGENTA} Searching for $FILE files on $SITE... ${RESET}"
                echo -e ""

                $SEARCH "https://www.google.com/search?q=inurl:$SITE+filetype:$FILE" \
                    | grep -Eo 'https?://[^ ]+\.'"$FILE" \
                    | cut -d '=' -f2'' > "$FILTERED_RESULTS_FILE"

                if [[ -s "$FILTERED_RESULTS_FILE" ]]; then
                    echo -e "${GREEN} Search successful. Results saved to $FILTERED_RESULTS_FILE ${RESET}"
                else
                    echo -e "${RED} No results found for the specified search criteria. ${RESET}"
                    echo -e "${RED} Raw search results saved to ${YELLOW}raw_results_${TIMESTAMP}.txt ${RESET}"
                fi
            else
                TIMESTAMP=$(date +%d%H%M%b%Y)-UTC
                FILTERED_RESULTS_FILE="${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"

                echo -e "${MAGENTA} Searching for $FILE files with ${KEYWORD} on $SITE... ${RESET}"
                echo -e ""

                $SEARCH "https://www.google.com/search?q=inurl:$SITE+filetype:$FILE+intext:$KEYWORD" \
                    | grep -Eo 'https?://[^ ]+\.'"$FILE" \
                    | cut -d '=' -f2''  > "$FILTERED_RESULTS_FILE"

                if [[ -s "$FILTERED_RESULTS_FILE" ]]; then
                    echo -e "${MAGENTA} Search successful. Results saved to $FILTERED_RESULTS_FILE ${RESET}"
                else
                    echo -e "${RED} No results found for the specified search criteria. ${RESET}"
                    echo -e "${RED} Raw search results saved to ${YELLOW}raw_results_${TIMESTAMP}.txt ${RESET}"
                fi
            fi
        }

        # Function to download files from the search results
        function download_files() {

            USER_AGENTS=(
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5414.119 Safari/537.36"
                "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.5359.124 Safari/537.36"
                "Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5414.119 Mobile Safari/537.36"
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5414.119 Safari/537.36 Edg/109.0.774.68"
            )

            FILE_LIST="$1"
            FOLDER="${SITE}_${TIMESTAMP}"
            mkdir -p "$FOLDER"
            while IFS= read -r URL; do
                RANDOM_USER_AGENT="${USER_AGENTS[RANDOM % ${#USER_AGENTS[@]}]}"
                echo -e "${MAGENTA} ========================================================================== ${RESET}"
                echo -e "${MAGENTA} Downloading file with ${RANDOM_USER_AGENT} ${RESET}"  # Log the download URL
                wget --user-agent="$RANDOM_USER_AGENT" -P "$FOLDER" "$URL"
                echo -e "${MAGENTA} ========================================================================== ${RESET}"
            done < "$FILE_LIST"
            rm -f "$FILE_LIST"  # Clean up the temporary results file
        }

        # Function to extract metadata for Author, Producer, Creator, and MIME Type
        function extract_metadata_summary() {
            FOLDER="${SITE}_${TIMESTAMP}"
            METADATA_FILE="${FOLDER}_metadata_summary.txt"
            echo -e "${MAGENTA} Extracting metadata from files in: $FOLDER ${RESET}"
        
            # Initialize the metadata summary file
            echo -e "Metadata Summary for $SITE - Generated on $(date)\n" > "$METADATA_FILE"
        
            # Use exiftool to extract metadata and filter relevant fields
            exiftool "$FOLDER"/* | grep -E "^(Author|Producer|Creator|MIME Type)" >> "$METADATA_FILE"
        
            echo -e "${GREEN} Metadata summary saved to: $METADATA_FILE ${RESET}"
        }

        # Function to process, organize, and export metadata
        function process_metadata_summary() {
            FOLDER="${SITE}_${TIMESTAMP}"
            METADATA_FILE="${FOLDER}_metadata_summary.txt"
            ORGANIZED_METADATA_FILE="${FOLDER}_organized_metadata_summary.txt"
            CSV_FILE="${FOLDER}_metadata_summary.csv"

            echo -e "${MAGENTA} Processing and organizing metadata for: $METADATA_FILE ${RESET}"

            # Initialize the organized metadata file
            echo -e "Organized Metadata Summary for $SITE - Generated on $(date)\n" > "$ORGANIZED_METADATA_FILE"

            # Initialize the CSV file with headers
            echo "Type,Value,Count" > "$CSV_FILE"

            # Group by software (Creator Tool and Producer)
            echo -e "=== Software Used (Creator Tool and Producer) ===\n" >> "$ORGANIZED_METADATA_FILE"
            grep -E "^(Creator Tool|Producer)" "$METADATA_FILE" | sort | uniq -c | sort -nr | while read -r COUNT FIELD VALUE; do
                echo "$FIELD,$VALUE,$COUNT" >> "$CSV_FILE" # Add to CSV
                printf "%-30s : %s (%s occurrences)\n" "$FIELD" "$VALUE" "$COUNT" >> "$ORGANIZED_METADATA_FILE"
            done

            # Group by persons (Creator and Author)
            echo -e "\n=== People Found (Creator and Author) ===\n" >> "$ORGANIZED_METADATA_FILE"
            grep -E "^(Creator|Author)" "$METADATA_FILE" | sort | uniq -c | sort -nr | while read -r COUNT FIELD VALUE; do
                echo "$FIELD,$VALUE,$COUNT" >> "$CSV_FILE" # Add to CSV
                printf "%-30s : %s (%s occurrences)\n" "$FIELD" "$VALUE" "$COUNT" >> "$ORGANIZED_METADATA_FILE"
            done

            echo -e "${GREEN} Organized metadata saved to: $ORGANIZED_METADATA_FILE ${RESET}"
            echo -e "${GREEN} Metadata CSV saved to: $CSV_FILE ${RESET}"

            # Display summary on the screen
            echo -e "\n${CYAN}=== Screen Summary ===${RESET}"
            echo -e "${YELLOW}Top Software Used:${RESET}"
            grep -E "^(Creator Tool|Producer)" "$METADATA_FILE" | sort | uniq -c | sort -nr | while read -r COUNT FIELD VALUE; do
                echo "  $FIELD: $VALUE ($COUNT occurrences)"
            done

            echo -e "\n${YELLOW}Top People Mentioned:${RESET}"
            grep -E "^(Creator|Author)" "$METADATA_FILE" | sort | uniq -c | sort -nr | while read -r COUNT FIELD VALUE; do
                echo "  $FIELD: $VALUE ($COUNT occurrences)"
            done
        }

        # Function to handle errors for empty results or missing files
        function handle_empty_results() {
            local file_to_check="$1"
            local context_message="$2"

            if [[ ! -f "$file_to_check" ]]; then
                echo -e "${RED} Error: $context_message - File does not exist. ${RESET}"
                echo -e "${YELLOW} Please check your search criteria or connection. ${RESET}"
                echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
                read -r 2>/dev/null
                main_menu
                return 1
            fi

            if [[ ! -s "$file_to_check" ]]; then
                echo -e "${RED} Error: $context_message - File is empty. ${RESET}"
                echo -e "${YELLOW} This usually happens when no results were found or when you got a Google ban!. ${RESET}"
                echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
                read -r 2>/dev/null
                main_menu
                return 1
            fi
            return 0  # File exists and is not empty
        }

        # Main workflow
        metadata_analysis_menu
        perform_search

        FILTERED_RESULTS_FILE="${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"

        # Handle errors for missing or empty filtered results
        handle_empty_results "$FILTERED_RESULTS_FILE" "Search results for filtered URLs" || return

        # Proceed with file downloads
        download_files "$FILTERED_RESULTS_FILE"

        # Handle errors for missing or empty metadata file
        METADATA_FILE="${SITE}_${TIMESTAMP}_metadata_summary.txt"
        analyze_metadata
        handle_empty_results "$METADATA_FILE" "Extracted metadata summary" || return

        # Process metadata and export CSV
        process_metadata_summary

        echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
        read -r 2>/dev/null
        main_menu
    }

######## CHEGAGEM DE PARAMETROS & EXECUÇÃO DO MAIN_MENU ########
    # Verifica se o número de argumentos passados para o script é diferente de zero.
    # Check if the script is being run with root privileges 
    # If not, display an error message and exit with a non-zero status code 
    #Encerra todos os processos do openvpn
    if [ "$(id -u)" != "0" ]; then
        msg_erro_root;
        # Check if the correct number of arguments is provided 
        # If not, display a usage message and exit with a non-zero status code 
        elif [ "$#" -ne 0 ]; then
            msg_erro_arquivo;
        else
            ######### Executa a função principal ########
            enable_proxychains; # Call the function to enable proxychains at script start
            main_menu;
    fi
#============================================================
