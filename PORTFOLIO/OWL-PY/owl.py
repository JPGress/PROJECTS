#!/usr/bin/env python
"""
owl.py - Secure Python CLI replacing owl.sh

Description:
This script replaces an older shell script (`owl.sh`) with a more secure Python implementation. 
It provides features like networking utilities, port scanning, web requests, and more.

Usage:
Run the script in the command line for various network and security tasks.
"""

#TODO:Add a more detailed header to explain the purpose, features, and usage of the script.
#TODO:Configure proxy chains for added security when the script is initialized.

# Import required modules
import argparse  # For handling command-line arguments.
import subprocess  # To execute system commands from the script.
import sys  # For system-specific parameters and functions.
import os  # For interacting with the operating system (e.g., file paths).
import socket  # Provides low-level networking interfaces.
import re  # Regular expressions for pattern matching.
import requests  # For making HTTP requests.
import whois  # To query WHOIS information about domains.
import dns.resolver  # For resolving DNS records.
import webbrowser  # To open web pages in the browser.
import time  # To handle time-related functions (e.g., delays, timestamps).
import threading # For threading operations.
import platform
from datetime import datetime, timezone  # For working with dates and timezones.
from concurrent.futures import ThreadPoolExecutor  # To perform tasks concurrently (multi-threading).
from urllib.parse import quote  # For encoding URLs.
from selenium import webdriver  # For automating web browser interactions
from selenium.webdriver.chrome.service import Service  # For managing the ChromeDriver service
from selenium.common.exceptions import WebDriverException  # For handling exceptions related to WebDriver operations
from selenium.webdriver.common.by import By  # For locating elements in Selenium
from selenium.webdriver.chrome.options import Options  # For configuring Chrome browser options
from queue import Queue # For implementing a thread-safe queue

# Define the top 1,000 most common ports
# Explanation:
# - The first 1,024 ports are standard (well-known ports) used by common services (e.g., HTTP, FTP, SSH).
# - Additional ports are included for commonly exploited services like MySQL (3306) and RDP (3389).
COMMON_PORTS = list(range(1, 1025)) + [  # Add the first 1,024 ports.
    3306,  # MySQL database
    3389,  # Remote Desktop Protocol (RDP)
    5900,  # Virtual Network Computing (VNC)
    8080,  # Alternative HTTP port
    8443,  # Alternative HTTPS port
    10000,  # Webmin (server management)
    5000,  # Flask (Python web framework default port)
    6379,  # Redis database
    27017  # MongoDB database
]

"""
AUXILIARY FUNCTIONS
"""

# Function to pause the script execution
def pause():
    # Pauses the script until the user presses Enter
    input("Press Enter to continue...")

# Extract subdomains from a webpage
def extract_subdomains(site):
    """
    Extract subdomains from the HTML content of a given site.

    Args:
        site (str): The URL of the site to analyze.

    Returns:
        list: Sorted unique subdomains extracted from the site's HTML.
    """
    try:
        response = requests.get(site)  # Fetch the webpage content
        html_content = response.text  # Extract the HTML as a string
        subdomains = re.findall(r'https?://([A-Za-z0-9.-]+)', html_content)  # Find subdomains
        return sorted(set(subdomains))  # Remove duplicates and sort
    except requests.RequestException as e:
        print(f"Error fetching URL {site}: {e}")
        return []  # Return an empty list if an error occurs

# Resolve subdomain IP addresses
def resolve_ip(subdomain):
    """
    Resolve IP addresses for a given subdomain using DNS.

    Args:
        subdomain (str): The subdomain to resolve.

    Returns:
        list: Resolved IP addresses or error messages.
    """
    try:
        answers = dns.resolver.resolve(subdomain, 'A')  # Query for A records
        return [answer.to_text() for answer in answers]  # Return IP addresses as strings
    except Exception as e:
        return [f"Error resolving IP for {subdomain}: {e}"]

# Fetch WHOIS information
def fetch_whois(domain):
    """
    Fetch WHOIS information for a domain.

    Args:
        domain (str): The domain to query.

    Returns:
        str: WHOIS information or an error message.
    """
    try:
        whois_info = whois.whois(domain)  # Query WHOIS data
        return whois_info.text if whois_info else "No WHOIS information available."
    except Exception as e:
        return f"Error fetching WHOIS for {domain}: {e}"

# Perform DNS lookup
def dns_lookup(domain):
    """
    Perform DNS lookup for A records of a domain.

    Args:
        domain (str): The domain to look up.

    Returns:
        str: Comma-separated IP addresses or an error message.
    """
    try:
        resolver = dns.resolver.Resolver()
        resolver.timeout = 5  # Set timeout for the query
        resolver.lifetime = 5  # Set maximum query duration
        answers = resolver.resolve(domain, 'A')  # Query A records
        return ", ".join([str(answer) for answer in answers])  # Join IP addresses as a string
    except Exception as e:
        return f"Error performing DNS lookup for {domain}: {e}"

# Prompt user for a target name (Google Hacking)
def menu_google_hacking():
    """
    Prompt the user to enter the name of a target for Google hacking.

    Returns:
        str: The target name entered by the user.
    """
    target_gh = input("Enter the name of the target to search: ")
    return target_gh

# Perform general Google searches
def pesquisa_geral(target_gh):
    """
    Perform general searches for a target on Webmii and Google.

    Args:
        target_gh (str): The target name to search for.
    """
    print("Searching WEBMII server...")
    webbrowser.open(f'https://webmii.com/people?n="{target_gh}"')  # Open Webmii search

    print("Searching all over Google...")
    webbrowser.open(f'https://www.google.com/search?q=intext:"{target_gh}"')  # Perform Google search

# Search for specific file types
def pesquisa_arquivo(target_gh, file_type, extensao):
    """
    Search Google for specific file types related to a target.

    Args:
        target_gh (str): The target name.
        file_type (str): The type of file to search for.
        extensao (str): The file extension (e.g., pdf, docx).
    """
    print(f'Searching for file type: {file_type}')
    webbrowser.open(f'https://www.google.com/search?q=filetype:"{extensao}"+intext:"{target_gh}"')  # File search

# Perform site-specific searches
def pesquisar_site(target_gh, site, domain_gh):
    """
    Search within a specific site for a target.

    Args:
        target_gh (str): The target name.
        site (str): A description of the site.
        domain_gh (str): The domain to search within.
    """
    print(f"Searching in {site}")
    webbrowser.open(f'https://www.google.com/search?q=inurl:"{domain_gh}"+intext:"{target_gh}"')  # Site search

# Validate if a string is a valid URL
def validate_url(url):
    """
    Validate a URL format.

    Args:
        url (str): The URL to validate.

    Returns:
        bool: True if the URL is valid, False otherwise.
    """
    return url.startswith("http") and "." in url

# Extract subdomains from a domain
def reverse_lookup_worker(address_queue, results, timeout):
    """
    Worker function to perform reverse DNS lookups concurrently.
    """
    while not address_queue.empty():
        try:
            full_address = address_queue.get()
            result = subprocess.check_output(
                ["host", "-t", "ptr", full_address],
                text=True,
                timeout=timeout
            )
            if "pointer" in result:
                ptr_record = result.split()[-1].strip()
                if ".ip-" not in ptr_record:  # Filter unwanted records
                    results.append(ptr_record)
        except subprocess.CalledProcessError:
            # Ignore errors for addresses without PTR records
            pass
        except subprocess.TimeoutExpired:
            print(f"Timeout expired for {full_address}")
        finally:
            address_queue.task_done()

# Perform DNS lookups in parallel
def worker(queue, domain, output_file, results_lock, progress):
    """
    Worker function to process DNS lookups and update progress.
    """
    while not queue.empty():
        subdomain = queue.get()
        full_domain = f"{subdomain}.{domain}"
        try:
            # Perform the DNS lookup using the `host` command
            result = subprocess.check_output(
                ["host", full_domain],
                text=True,
                stderr=subprocess.DEVNULL
            )
            # Write the result to the output file
            with results_lock:
                with open(output_file, 'a') as f:
                    f.write(result)
        except subprocess.CalledProcessError:
            # Ignore subdomains that don't resolve
            pass
        finally:
            # Update progress counter
            with progress['lock']:
                progress['count'] += 1
                if progress['count'] % 100 == 0:  # Print progress every 100 subdomains
                    print(f"Processed {progress['count']} subdomains...")
            queue.task_done()

# Get information about the network interface
def get_interface_and_network():
    """
    Identify the network interface and calculate the network range.
    """
    try:
        # Get the network interface starting with "tap"
        interface = subprocess.check_output(
            "ip -br a | grep tap | head -n 1 | cut -d ' ' -f1", shell=True, text=True
        ).strip()

        if not interface:
            raise ValueError("No network interface starting with 'tap' found.")

        # Get the network range
        network = subprocess.check_output(
            f"ipcalc $(ip -br a | grep tap | head -n 1 | awk '{{print $3}}' | awk -F '/' '{{print $1}}') "
            f"| grep -F 'Network:' | awk '{{print $2}}'",
            shell=True,
            text=True
        ).strip()

        if not network:
            raise ValueError("Unable to calculate the network range.")

        return interface, network
    except subprocess.CalledProcessError as e:
        print(f"Error determining network interface or range: {e}")
        exit(1)

# Enable packet forwarding in the system
def enable_packet_routing():
    """
    Enable packet forwarding in the system.
    """
    try:
        with open("/proc/sys/net/ipv4/ip_forward", "w") as f:
            f.write("1")
        print("Packet routing enabled.")
    except Exception as e:
        print(f"Failed to enable packet routing: {e}")
        exit(1)

# Setup the MITM environment
def setup_mitm_environment(interface, network):
    """
    Set up the Man-in-the-Middle attack environment.
    """
    try:
        # Change the MAC address for the interface
        subprocess.run(f"macchanger -r {interface}", shell=True, check=True)
        print("MAC address changed.")

        # Run Netdiscover in a new terminal
        print("Launching Netdiscover...")
        subprocess.Popen(
            f"tilix --action=app-new-window --command='netdiscover -i {interface} -r {network}'",
            shell=True
        )
        time.sleep(10)

        # Ask the user for target IPs
        target1 = input("Enter the IP of target 1 (ALV01): ").strip()
        target2 = input("Enter the IP of target 2 (ALV02): ").strip()

        # Launch ARP spoofing in a new terminal
        print("Starting ARP spoofing...")
        subprocess.Popen(
            f"tilix --action=app-new-session --command='arpspoof -i {interface} -t {target1} -r {target2}'",
            shell=True
        )

        # Start capturing traffic with Tcpdump
        print("Starting packet capture with Tcpdump...")
        tcpdump_command = (
            f"tcpdump -i {interface} host {target1} and host {target2} | "
            f"grep -E '\\[P.\\]' | grep -E 'PASS|USER|html|GET|pdf|jpeg|jpg|png|txt' | tee capturas.txt"
        )
        subprocess.run(tcpdump_command, shell=True)

    except subprocess.CalledProcessError as e:
        print(f"Error setting up MITM environment: {e}")
        exit(1)

# Scan a network for open ports
def scan_port(host, port, timeout=0.5):
    """
    Check if a specific port is open on a given host.
    """
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(timeout)
            result = s.connect_ex((host, port))
            if result == 0:
                return port
    except Exception:
        pass
    return None

#!FIXME: Need to fix the export_to_file function
# Export the content to a text file.
def export_to_file(content):
    """
    Export the content to a text file.
    """
    file_name = "linux_commands_help.txt"
    with open(file_name, "w") as f:
        f.write(content)
    print(f"\nContent exported to {file_name}")

# Execute a shell command and display the output.
def execute_command(command):
    """
    Execute a shell command and display the output.
    """
    try:
        print(f"\nExecuting: {command}\n")
        subprocess.run(command.split(), check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")
    except FileNotFoundError:
        print(f"Command not found: {command}")

# List the ARP table.
def list_arp_table():
    """
    List the ARP table.
    """
    print("\n## List ARP Table\n")
    print("Command: arp -a")
    if input("Press 'b' to go back or Enter to execute the command: ").lower() == 'b':
        return
    execute_command("arp -a")

# Display configured IPs.
def display_ips():
    """
    Display configured IPs.
    """
    print("\n## Display Configured IPs\n")
    print("Commands:\n1. ifconfig -a (Net-tools)\n2. ip addr (IP route)")
    choice = input("Select command to execute (1 for ifconfig, 2 for ip addr, b to go back): ").lower()
    if choice == "b":
        return
    elif choice == "1":
        execute_command("ifconfig -a")
    elif choice == "2":
        execute_command("ip addr")
    else:
        print("Invalid selection.")

# Enable or disable a network interface.
def enable_disable_interface():
    """
    Enable or disable a network interface.
    """
    print("\n## Enable/Disable a Network Interface\n")
    choice = input("Press 'b' to go back or Enter to continue: ").lower()
    if choice == 'b':
        return

    interface = input("Enter the interface name (e.g., eth0): ").strip()
    action = input("Enter 'up' to enable or 'down' to disable: ").strip()
    print(f"\nCommand: ip link set {interface} {action}")
    execute_command(f"ip link set {interface} {action}")

# Display active network connections.
def display_active_connections():
    """
    Display active network connections.
    """
    print("\n## Display Active Connections\n")
    print("Commands:\n1. netstat (Net-tools)\n2. ss (IP route)")
    choice = input("Select command to execute (1 for netstat, 2 for ss, b to go back): ").lower()
    if choice == "b":
        return
    elif choice == "1":
        execute_command("netstat")
    elif choice == "2":
        extra = input("Add arguments (e.g., -lntp) or press Enter to skip: ").strip()
        command = f"ss {extra}" if extra else "ss"
        execute_command(command)
    else:
        print("Invalid selection.")

# Display routes.
def display_routes():
    """
    Display routes.
    """
    print("\n## Display Routes\n")
    print("Commands:\n1. route (Net-tools)\n2. ip route (IP route)")
    choice = input("Select command to execute (1 for route, 2 for ip route, b to go back): ").lower()
    if choice == "b":
        return
    elif choice == "1":
        execute_command("route")
    elif choice == "2":
        execute_command("ip route")
    else:
        print("Invalid selection.")

# Execute a 'find' command and display the results.
def execute_find_command(command):
    """
    Execute a 'find' command and display the results.
    """
    try:
        print(f"\nExecuting: {command}\n")
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")
    except FileNotFoundError:
        print("Command 'find' is not available on this system.")


# Check if the required modules are installed
"""
#def check_requirements(skip_selenium=False):
#    
#    Check if Selenium, ChromeDriver, and Chromium are properly configured, 
#    unless skip_selenium is True.
#    
#    Args:
#        skip_selenium (bool): If True, skip Selenium-related checks.
#    
#    print("[INFO] Checking requirements...")
#
#    # Skip Selenium-related checks if the flag is set
#    if skip_selenium:
#        print("[INFO] Skipping Selenium-related checks due to --skip-selenium flag.")
#        return True
#
#    # Check Selenium installation
#    try:
#        import selenium
#        print("[INFO] Selenium is installed.")
#    except ImportError:
#        print("[ERROR] Selenium is not installed.")
#        if input("Do you want to install Selenium? (yes/no): ").strip().lower() in ["yes", "y"]:
#            try:
#                subprocess.run(["pip", "install", "selenium", "--break-system-packages"], check=True)
#                print("[INFO] Selenium installed successfully.")
#            except subprocess.CalledProcessError as e:
#                print(f"[ERROR] Failed to install Selenium: {e}")
#                return False
#        else:
#            return False
#
#    # Check ChromeDriver
#    try:
#        service = Service("/usr/bin/chromedriver")  # Adjust path if needed
#        driver = webdriver.Chrome(service=service)
#        driver.quit()
#        print("[INFO] ChromeDriver is available and working.")
#    except WebDriverException as e:
#        print(f"[ERROR] ChromeDriver is not available or not working: {e}")
#        return False
#
#    print("[INFO] All requirements are met.")
#    return True
""" 

"""
MAIN MENU FUNCTION
"""
def texto_main_menu():
    """
    Main menu display function.
    This function clears the screen, displays a stylized menu header, and lists options for the user to choose from.
    
    Returns:
        str: The user's selected option as input.
    """
    # Clear the terminal screen for better readability
    # 'cls' is used for Windows systems, while 'clear' is for Unix-based systems (e.g., Linux, macOS).
    os.system('cls' if os.name == 'nt' else 'clear')

    # Display the menu header with ASCII art
    print("")
    print(" ██████╗     ██████╗ ██╗    ██╗██╗         ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗")
    print("██╔═████╗   ██╔═████╗██║    ██║██║         ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝")
    print("██║██╔██║   ██║██╔██║██║ █╗ ██║██║         ███████╗██║     ██████╔╝██║██████╔╝   ██║   ")
    print("████╔╝██║   ████╔╝██║██║███╗██║██║         ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ")
    print("╚██████╔╝██╗╚██████╔╝╚███╔███╔╝███████╗    ███████║╚██████╗██║  ██║██║██║        ██║   ")
    print(" ╚═════╝ ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ")
    print(" v 0.9                                                                                 ")   
    print("+===================================== 0.0wL =========================================+")
    print("+                           Made by JPGreSS a.k.a R3v4N||0wL                          +")
    print("+=====================================================================================+")

    # Define the list of menu options
    options = [
        "Portscan",
        "Parsing HTML",
        "Google Hacking",
        "Metadata analysis (unstable)",
        "DNS Zone Transference",
        "SubDomain Take Over",
        "DNS reverse",
        "DNS recon",
        "OSINTool",
        "MiTM",
        "Portscan (bash sockets)",
        "Useful commands for network management",
        "Examples of the find command",
        "Debian root password change memo",
        "Red Hat root password change memo",
        "Vim usage memento",
        "rbash escaping techniques (function under test)",
        "Wireless Network Attacks",
        "Windows Tip Reminders",
        "NMAP Network Scanner",
        "xxxxx",
        "xxiv_revshell_windows",
        "xxv_rdp_windows"
    ]

    # Print each menu option with a numeric index
    for i, option in enumerate(options, 1):  # Starts enumeration at 1
        print(f"{i} - {option}")  # Prints the menu option with its number
    print("+==============================================+")
    print(" Enter 0(zero) to exit")  # Provide an option to exit the menu
    print("+==============================================+")

    # Prompt the user for a menu selection
    choice = input("Enter option number: ").strip()  # Strips extra spaces from input
    return choice  # Return the user's choice as a string

"""
MAIN FUNCTION
"""
def main():
    """
    The main function serves as the entry point for the Owl CLI tool.
    It initializes the argument parser, displays the menu, and handles user choices.
    """
    # Initialize the argument parser
    parser = argparse.ArgumentParser(
        description="Owl is a Python-based CLI tool designed for streamlined automation of system operations and security tasks."
    )

    # Add optional arguments to the parser
    parser.add_argument(
        "--skip-selenium",
        action="store_true",
        help="Skip Selenium-related checks for development or debugging purposes."
    )

    # Parse the command-line arguments
    args = parser.parse_args()

    # Check requirements, with an option to skip Selenium checks
    #if not check_requirements(skip_selenium=args.skip_selenium):
    #    print("[ERROR] Requirements not met. Exiting.")
    #    return

    # Infinite loop to display the menu repeatedly until the user exits
    while True:
        # Display the main menu and capture the user's choice
        choice = texto_main_menu()

        # Handle user choice
        if choice == "0":  # Exit option
            print("Exiting Owl. Goodbye!")
            break

        elif choice == "1":  # Port scanning
            target_ip = input("Enter target IP or hostname: ").strip()
            start_port = input("Enter the starting port (or leave blank for default): ").strip()
            end_port = input("Enter the ending port (or leave blank for default): ").strip()
            verbose = args.verbose or input("Verbose output? (yes/no, default no): ").strip().lower() in ["yes", "y"]

            start_port = int(start_port) if start_port else None
            end_port = int(end_port) if end_port else None

            result_file = i_port_scan(target_ip, start_port, end_port, verbose)
            print(f"Results stored in: {result_file}")

        elif choice == "2":  # HTML parsing
            ii_parsing_html()

        elif choice == "3":  # Google hacking
            iii_google_hacking()

        elif choice == "4":  # Metadata analysis
            print("[>>> WARNING! <<<] Metadata analysis requires Selenium. This function is unstable [>>> WARNING! <<<]")
            pause()
            iv_metadata_analysis()

        elif choice == "5":  # DNS Zone Transfer
            v_dns_zt()
            
        elif choice == "6":  # Subdomain Takeover
            vi_subdomain_takeover()
        
        elif choice == "7":  # DNS reverse
            vii_rev_dns()
            
        elif choice == "8":  # DNS recon
            viii_recon_dns()
            
        elif choice == "9":  # OSINT Tool
            ix_general_google_query()
            
        elif choice == "10":  # MiTM
            print("[>>> WARNING! <<<] This feature is not fully tested. Proceed at your own risk. [>>> WARNING! <<<]")
            pause()
            x_mitm()
            
        elif choice == "11":  # Portscan (bash sockets)
            xi_portscan_bashsocket()
            
        elif choice == "12":  # Useful commands for Linux network management
            xii_useful_linux_commands()
            
        elif choice == "13":  # Examples of the find command
            xiii_find_examples()
            
        elif choice == "14":  # Red Hat root password change memo
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "15":  # Vim usage memento
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "16":  # rbash escaping techniques
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "17":  # Wireless Network Attacks
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "18":  # Windows Tip Reminders
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "19":  # NMAP Network Scanner
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "20":  # xxxxx
            print("[WARNING] This function is not implemented yet")
            pause()
            
        elif choice == "21":  # xxiv_revshell_windows
            print("[WARNING] This function is not implemented yet")
            pause()
            
        else:  # Invalid input handling
            print("[ERROR] Invalid choice. Please try again.")

"""
Menu functions
"""
def i_port_scan(target: str, start_port: int = None, end_port: int = None, verbose: bool = False) -> str:
    """
    Perform a TCP port scan on a target and save the results to a timestamped .txt file.

    :param target: The target IP or hostname to scan.
    :param start_port: The starting port number. Defaults to None, using COMMON_PORTS.
    :param end_port: The ending port number. Defaults to None, using COMMON_PORTS.
    :param verbose: If True, prints details of open ports.
    :return: The filename where the scan results are saved.
    """
    # Define a helper function for scanning a single port
    def scan_port(port):
        try:
            # Create a socket using IPv4 (AF_INET) and TCP (SOCK_STREAM)
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(1)  # Set a timeout for the connection attempt (1 second)
                result = sock.connect_ex((target, port))  # Try connecting to the port
                if result == 0:  # If the result is 0, the port is open
                    if verbose:
                        print(f"Port {port}: OPEN")
                    return port  # Return the open port
        except Exception as e:
            if verbose:  # If verbose is enabled, print the error
                print(f"[ERROR] Port {port} scan failed: {e}")
        return None  # Return None if the port is closed or an error occurs

    # Determine the range of ports to scan
    # If start_port and end_port are specified, create a range from start_port to end_port.
    # Otherwise, use the predefined COMMON_PORTS list.
    ports_to_scan = range(start_port, end_port + 1) if start_port and end_port else COMMON_PORTS

    # Notify the user about the scanning process
    print(f"Scanning target {target} on ports: {', '.join(map(str, ports_to_scan[:10]))}... (and more)")

    open_ports = []  # Initialize a list to store open ports

    # Use multithreading for faster scanning
    with ThreadPoolExecutor(max_workers=50) as executor:
        # Submit port scan tasks to the executor
        futures = {executor.submit(scan_port, port): port for port in ports_to_scan}
        for future in futures:
            port_result = future.result()  # Wait for each scan result
            if port_result:
                open_ports.append(port_result)  # Add open ports to the list

    # Generate a timestamped filename for the scan report
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"scan_{timestamp}.txt"

    # Write the scan results to the file
    with open(filename, "w") as file:
        file.write(f"Scan Report for {target}\n")
        file.write(f"Scanned Ports: {start_port or 'N/A'}-{end_port or 'Top 1k Common Ports'}\n")
        file.write("Open Ports:\n")
        if open_ports:
            # List all open ports in the report
            for port in open_ports:
                file.write(f"- Port {port}: OPEN\n")
        else:
            file.write("No open ports found.\n")  # Indicate if no open ports were found

    # Notify the user that the scan is complete and results are saved
    print(f"[INFO] Scan completed. Results saved to {filename}")

    # Pause to let the user view the result before continuing
    pause()  # Wait for user input (e.g., pressing Enter)
    print("Continuing with the script...")

    return filename  # Return the name of the results file

def ii_parsing_html():
    """
    Analyze the HTML of a given site to extract subdomains, resolve their IPs,
    fetch WHOIS information, and perform DNS lookups. Saves the results to a timestamped file.
    """
    # Prompt the user to enter the URL of the site to analyze
    site = input("Enter the URL of the site to analyze: ").strip()

    # Generate a timestamp for the report filename
    now = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    output_file = f"result_{now}.txt"  # Name the output file with the current timestamp

    # Open the output file in write mode
    with open(output_file, 'w') as output:
        # Write the report header
        output.write(f"Report generated on: {now}\n\n")

        # Extract subdomains from the site using the `extract_subdomains` function
        subdomains = extract_subdomains(site)

        # Handle cases where no subdomains are found
        if not subdomains:
            print(f"No subdomains found for: {site}")  # Notify the user
            output.write(f"No subdomains found for: {site}\n")  # Log to the file
        else:
            print(f"Found subdomains for {site}:")  # Notify the user of progress
            for subdomain in subdomains:  # Loop through the extracted subdomains
                print(f"Analyzing: {subdomain}")  # Display progress in the terminal
                output.write(f"Subdomain: {subdomain}\n")  # Write the subdomain to the file

                # Resolve the IP addresses of the subdomain
                ips = resolve_ip(subdomain)
                output.write(f"IP Addresses: {', '.join(ips)}\n")  # Write the IPs to the file

                # Fetch WHOIS information for the subdomain
                whois_data = fetch_whois(subdomain)
                output.write(f"WHOIS Info:\n{whois_data}\n")  # Write WHOIS data to the file

                # Perform a DNS lookup for the subdomain
                dns_info = dns_lookup(subdomain)
                output.write(f"DNS Lookup: {dns_info}\n")  # Write DNS lookup results to the file

                output.write("\n")  # Add a newline for readability between subdomains

    # Notify the user that the analysis is complete and where the results are saved
    print(f"Analysis complete. Results saved in: {output_file}")

    # Pause to let the user review the message before continuing
    pause()
    print("Continuing with the script...")

def iii_google_hacking():
    """
    Main function to perform Google hacking.
    Uses predefined file types and websites to search for information related to a target.
    """
    # Prompt the user to enter the target name
    target_gh = menu_google_hacking()

    # Perform general Google searches for the target
    pesquisa_geral(target_gh)

    # Predefined list of file types and their extensions
    tipos = ["PDF", "ppt", "Doc", "Docx", "xls", "xlsx", "ods", "odt", "TXT", "PHP", "XML", "JSON", "PNG", "SQLS", "SQL"]
    extensoes = ["pdf", "ppt", "doc", "docx", "xls", "xlsx", "ods", "odt", "txt", "php", "xml", "json", "png", "sqls", "sql"]

    # Iterate over file types and extensions to perform file-specific searches
    for file_type, extensao in zip(tipos, extensoes):
        # Perform a Google search for files of a specific type related to the target
        pesquisa_arquivo(target_gh, file_type, extensao)

    # Predefined list of sites and their corresponding domains
    sites = ["Governo", "Pastebin", "Trello", "Github", "LinkedIn", "Facebook", "Twitter", "Instagram", "TikTok", "youtube", "Medium", "Stack Overflow", "Quora", "Wikipedia"]
    dominios = [".gov.br", "pastebin.com", "trello.com", "github.com", "linkedin.com", "facebook.com", "twitter.com", "instagram.com", "tikTok.com", "youtube.com", "medium.com", "stackoverflow.com", "quora.com", "wikipedia.org"]

    # Iterate over sites and domains to perform site-specific searches
    for site, domain_gh in zip(sites, dominios):
        # Perform a Google search within a specific domain for the target
        pesquisar_site(target_gh, site, domain_gh)

    # Pause to let the user review the results before continuing
    pause()

def iv_metadata_analysis():
    """
    Perform metadata analysis by searching for files using Selenium.
    """

    def menu_metadata_analysis():
        """
        Prompt the user to enter search parameters for metadata analysis.

        Returns:
            tuple: A tuple containing the site extension, file type, and optional keyword.
        """
        site = input("Enter the URL extension to search (e.g., .gov.br): ").strip()
        filetype = input("Enter the file extension to search (e.g., .pdf): ").strip()
        keyword = input("Enter a keyword (optional): ").strip()
        return site, filetype, keyword

    def perform_search(site, filetype, keyword=""):
        """
        Use Selenium to search for files based on user-provided parameters.

        Args:
            site (str): The domain or site extension (e.g., .gov.br).
            filetype (str): The file extension to search for (e.g., pdf).
            keyword (str): An optional keyword to refine the search.

        Returns:
            list: A list of URLs found during the search.
        """
        query = f"inurl:{site} filetype:{filetype}"
        if keyword:
            query += f" intext:{keyword}"

        # Set up headless Chrome
        options = Options()
        options.binary_location = "/usr/bin/chromium"  # Path to Chromium
        #options.add_argument("--headless")  # Enable headless mode
        options.add_argument("--no-sandbox")  # Disable the sandbox
        options.add_argument("--disable-gpu")  # Disable GPU rendering
        options.add_argument("--disable-dev-shm-usage")  # Use /dev/shm efficiently
        options.add_argument("--disable-software-rasterizer")  # Avoid software rendering
        options.add_argument("--remote-debugging-port=9222")  # Open debugging port
        options.add_argument("--window-size=1920,1080")  # Set a default window size
        options.add_argument("--disable-extensions")  # Disable extensions
        options.add_argument("--disable-infobars")  # Prevent infobars
        options.add_argument("--disable-browser-side-navigation")  # Improve navigation stability
        options.add_argument("--disable-blink-features=AutomationControlled")  # Mimic human usage



        # Open the browser and perform the search
        service = Service(executable_path="/usr/bin/chromedriver")  # Adjust path as needed
        with webdriver.Chrome(service=service, options=options) as driver:
            driver.get(f"https://www.google.com/search?q={query}")

            # Extract URLs from search results
            links = driver.find_elements(By.TAG_NAME, "a")
            urls = [link.get_attribute("href") for link in links if link.get_attribute("href")]
            return [url for url in urls if url.startswith("http")]

    def download_files(urls, folder):
        """
        Download files from a list of URLs into a specified folder.

        Args:
            urls (list): A list of URLs to download.
            folder (str): The folder where the downloaded files will be saved.
        """
        os.makedirs(folder, exist_ok=True)
        for url in urls:
            try:
                print(f"Downloading: {url}")
                subprocess.run(["wget", "-P", folder, url], check=True)
            except subprocess.CalledProcessError:
                print(f"Failed to download: {url}")

    def extract_metadata(folder):
        """
        Extract metadata from all files in the specified folder using exiftool.

        Args:
            folder (str): The folder containing files for metadata extraction.
        """
        if not os.listdir(folder):
            print("No files found for metadata extraction.")
            return
        subprocess.run(["exiftool", "./*"], cwd=folder, check=True)

    # Step 1: Prompt the user for search parameters
    site, filetype, keyword = menu_metadata_analysis()

    # Step 2: Perform the search and retrieve URLs
    results = perform_search(site, filetype, keyword)

    # Step 3: Process the search results
    if results:
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        folder_name = f"{site}_{timestamp}_results"
        download_files(results, folder_name)
        extract_metadata(folder_name)
    else:
        print("No results found.")

def v_dns_zt():
    print("DNS Zone Transfer")

    # Validate target domain input
    target = input("Enter the target domain (e.g., example.com): ").strip()
    if not re.match(r"^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", target):
        print("Invalid domain. Please enter a valid domain name.")
        return

    try:
        # Get nameservers for the target domain
        print(f"Retrieving nameservers for {target}...")
        ns_command = ["dig", "NS", target]
        ns_output = subprocess.check_output(ns_command, text=True).splitlines()

        # Extract nameservers from the output
        ns_servers = [line.split()[-1] for line in ns_output if "NS" in line and line.startswith(target)]
        if not ns_servers:
            print("No nameservers found.")
            return

        # Attempt zone transfers from each nameserver
        for server in ns_servers:
            print(f"\nAttempting zone transfer on nameserver: {server}")
            zone_command = ["dig", "AXFR", target, f"@{server}"]
            try:
                zone_output = subprocess.check_output(zone_command, text=True)
                print(zone_output)
            except subprocess.CalledProcessError as e:
                print(f"Zone transfer failed for {server}: {e}")

    except subprocess.CalledProcessError as e:
        print(f"Error retrieving nameservers: {e}")

    pause()

def vi_subdomain_takeover():
    print("Subdomain Takeover Vulnerability Scanner")

    # Step 1: Get the target host and validate the format
    host = input("Enter the host for the Subdomain takeover attack (e.g., example.com): ").strip()
    if not re.match(r"^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", host):
        print("Invalid host format. Please enter a valid domain.")
        return

    # Step 2: Get the file path and validate its existence
    file_path = input("Enter the path to the file with subdomains: ").strip()
    if not os.path.isfile(file_path):
        print(f"Error: The file '{file_path}' does not exist or is inaccessible.")
        return

    # Step 3: Open the file and process each subdomain
    try:
        with open(file_path, 'r') as file:
            for line in file:
                domain = line.strip()
                full_domain = f"{domain}.{host}"
                
                # Use subprocess to safely execute the CNAME query
                try:
                    result = subprocess.check_output(["host", "-t", "cname", full_domain], text=True)
                    
                    # Check for CNAME alias in the output
                    if "is an alias for" in result:
                        print(f"[CNAME Found] {full_domain}: {result.strip()}")
                
                except subprocess.CalledProcessError as e:
                    print(f"Error querying {full_domain}: {e}")

    except Exception as e:
        print(f"An error occurred while reading the file: {e}")

    # Step 4: Wait for user input before continuing
    pause()

    # Step 5: Return to the main menu (if applicable)
    # Ensure 'main()' is defined elsewhere in the code
    if 'main' in globals():
        main()
    else:
        print("Returning to the main program...")

def vii_rev_dns():
    print("DNS Reverse Lookup")

    # Step 1: Get the base address for the reverse DNS lookup
    base_address = input("Enter the base address for the DNS reverse lookup (e.g., 192.168.1): ").strip()

    # Step 2: Get the start and end of the IP range
    try:
        start = int(input("Enter the start of the IP range: ").strip())
        end = int(input("Enter the end of the IP range: ").strip())
    except ValueError:
        print("Invalid input. Please enter valid numbers.")
        return

    # Validate IP range
    if start < 0 or end > 255 or start > end:
        print("Invalid range. Please enter a valid range (0-255).")
        return

    # Step 3: Output file setup
    output_file = f"{base_address}.{start}-{end}.txt"
    if os.path.exists(output_file):
        os.remove(output_file)

    # Step 4: Create a queue with all addresses
    address_queue = Queue()
    for i in range(start, end + 1):
        address_queue.put(f"{base_address}.{i}")

    # Step 5: Start worker threads for reverse lookup
    results = []
    num_threads = 10  # Number of concurrent threads
    timeout = 5       # Timeout for each lookup in seconds
    threads = []

    for _ in range(num_threads):
        thread = threading.Thread(target=reverse_lookup_worker, args=(address_queue, results, timeout))
        threads.append(thread)
        thread.start()

    try:
        # Wait for all threads to finish
        for thread in threads:
            thread.join()
    except KeyboardInterrupt:
        print("\nExecution interrupted by user.")
        return

    # Step 6: Write results to the output file
    with open(output_file, 'w') as f:
        for record in results:
            f.write(record + '\n')

    # Step 7: Display results to the user
    print(f"\nReverse DNS lookup completed. Results saved to: {output_file}")
    with open(output_file, 'r') as f:
        print(f.read())

    pause()

    # Placeholder for returning to the main menu (ensure 'main_menu()' is defined elsewhere)
    main()

def viii_recon_dns():
    """
    Perform DNS reconnaissance using multithreading for faster processing.
    
    TODO: This function needs to be tested and refined for better performance.
    """
    wordlist_path = "/usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt"

    # Step 1: Load the subdomain wordlist
    try:
        with open(wordlist_path, 'r') as file:
            subdomains = [line.strip() for line in file if line.strip()]
    except FileNotFoundError:
        print(f"Error: Wordlist file not found at {wordlist_path}.")
        return

    total_lines = len(subdomains)
    if total_lines == 0:
        print("Error: Wordlist is empty.")
        return

    print("DNS Recon")

    # Step 2: Prompt the user for the domain to test
    domain = input("Enter the domain for DNS recon (e.g., businesscorp.com.br): ").strip()
    if not domain:
        print("Error: Domain input cannot be empty.")
        return

    # Step 3: Initialize the output file
    output_file = f"dns_recon_{domain}.txt"
    with open(output_file, 'w') as f:
        f.write("")  # Clear the file if it already exists

    # Step 4: Set up threading
    queue = Queue()
    results_lock = threading.Lock()  # Lock for safely writing to the output file

    # Enqueue all subdomains
    for subdomain in subdomains:
        queue.put(subdomain)

    # Progress tracking dictionary
    progress = {'count': 0, 'lock': threading.Lock()}

    # Step 5: Create worker threads
    num_threads = 20  # Adjust this value based on your system's capability
    threads = []

    for _ in range(num_threads):
        thread = threading.Thread(target=worker, args=(queue, domain, output_file, results_lock, progress))
        threads.append(thread)
        thread.start()

    # Wait for all threads to finish
    try:
        for thread in threads:
            thread.join()
    except KeyboardInterrupt:
        print("\nExecution interrupted by user.")
        return

    # Step 6: Display final message and progress
    print(f"\nRecon completed. Results saved to: {output_file}")
    pause()
    main()

def ix_general_google_query():
    """
    Perform a general query on Google using Selenium with a user-provided CSV file.
    """
    print("General Google Query")

    # Step 1: Prompt the user to provide the CSV file path
    lista_path = input("Enter the path to the CSV file with queries (e.g., queries.csv): ").strip()
    try:
        with open(lista_path, 'r') as csv_file:
            csv_reader = csv.reader(csv_file)
            queries = [(row[0], row[1]) for row in csv_reader]  # Extract (name, CPF) pairs
    except FileNotFoundError:
        print(f"Error: File not found at {lista_path}. Please try again.")
        return
    except IndexError:
        print(f"Error: The file {lista_path} does not have the required columns. Please check the format.")
        return

    # Step 2: Set up Selenium WebDriver (Chrome in this case)
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")  # Run in headless mode (no GUI)
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    driver = webdriver.Chrome(options=options)

    # Step 3: Iterate over the queries
    for name, cpf in queries:
        print("===")
        print(f"Searching for: {name} + {cpf}")

        # Step 3.1: Construct the Google search URL
        search_url = f"https://www.google.com/search?q=intext:{name}+intext:{cpf}"

        # Step 3.2: Perform the Google search
        try:
            driver.get(search_url)
            time.sleep(2)  # Wait for results to load (adjust if needed)

            # Step 3.3: Extract search results (filtering for links to PDFs)
            results = driver.find_elements(By.XPATH, "//a[contains(@href, '.pdf')]")
            for result in results:
                pdf_link = result.get_attribute("href")
                if pdf_link:  # Filter out empty links
                    print(pdf_link)
        except Exception as e:
            print(f"Error during search: {e}")

        # Step 3.4: Wait for the user to press Enter before proceeding
        input("Press Enter to continue to the next search...")

    # Step 4: Clean up and close the WebDriver
    driver.quit()
    print("============ End of Query ===========")

    # Return to the main menu
    main()

def x_mitm():
    """
    Main function for executing a Man-in-the-Middle attack.
    """
    # Step 1: Get interface and network range
    try:
        interface, network = get_interface_and_network()
    except ValueError as e:
        print(e)
        exit(1)

    # Step 2: Display initial message
    print("============= 0.0wL =============")
    print(f"ATTACK INTERFACE: {interface}")
    print(f"ATTACK NETWORK: {network}")
    print("=================================")

    # Step 3: Enable packet routing
    enable_packet_routing()

    # Step 4: Set up the MITM environment
    setup_mitm_environment(interface, network)

    # Step 5: End the script and return to the main menu
    input("Press Enter to continue...")
    main()

def xi_portscan_bashsocket():
    """
    Perform a port scan on a target host using Python sockets and multithreading.
    """
    print("Enhanced Socket-based Port Scanner")
    
    # Step 1: Get user input
    target_host = input("Enter the target for the port scan (e.g., 192.168.9.5): ").strip()
    if not target_host:
        print("Error: No target provided. Exiting.")
        return

    # Validate IP address
    try:
        socket.inet_aton(target_host)
    except socket.error:
        print(f"Error: Invalid IP address '{target_host}'. Exiting.")
        return

    try:
        start_port = int(input("Enter the starting port (default: 1): ") or 1)
        end_port = int(input("Enter the ending port (default: 1024): ") or 1024)
    except ValueError:
        print("Error: Invalid port range. Exiting.")
        return

    # Step 2: Perform the port scan
    print(f"Scanning {target_host} from port {start_port} to {end_port}...")
    start_time = time.time()

    open_ports = []
    with ThreadPoolExecutor(max_workers=50) as executor:  # 50 concurrent threads
        futures = [executor.submit(scan_port, target_host, port) for port in range(start_port, end_port + 1)]
        for future in futures:
            result = future.result()
            if result is not None:
                open_ports.append(result)

    # Step 3: Display results
    end_time = time.time()
    scan_duration = end_time - start_time
    if open_ports:
        print(f"Open ports on {target_host}: {', '.join(map(str, open_ports))}")
    else:
        print(f"No open ports found on {target_host}.")

    print(f"Scan completed in {scan_duration:.2f} seconds.")
    input("Press Enter to continue...")
    main()

# Main function for displaying useful Linux commands and allowing interaction.
def xii_useful_linux_commands():
    """
    Main function for displaying useful Linux commands and allowing interaction.
    """
    if platform.system() != "Linux":
        print("This script is designed to run on Linux systems. Exiting.")
        return

    while True:
        # Display the main menu
        commands_description = """
>>>>>>>>>> LINUX COMMANDS <<<<<<<<<<

1. List ARP Table
2. Display Configured IPs
3. Enable/Disable a Network Interface
4. Display Active Connections
5. Display Routes
6. Export Commands to File
7. Back to Main Menu
"""

        print(commands_description)

        try:
            choice = int(input("Select an option (1-7): "))
            if choice == 1:
                list_arp_table()
            elif choice == 2:
                display_ips()
            elif choice == 3:
                enable_disable_interface()
            elif choice == 4:
                display_active_connections()
            elif choice == 5:
                display_routes()
            elif choice == 6:
                export_to_file(commands_description)
            elif choice == 7:
                print("Returning to Main Menu...")
                break
            else:
                print("Invalid choice. Please select a valid option.")
        except ValueError:
            print("Invalid input. Please enter a number.")

# Display examples of the 'find' command and allow the user to run custom searches.
def xiii_find_examples():
    """
    Display examples of the 'find' command and allow the user to run custom searches.
    """
    while True:
        # Display the header
        os.system('clear')
        print("\n>>>>>>>>>> LINUX COMMANDS - FIND & EXAMPLES <<<<<<<<<<\n")

        # Display examples
        examples = """
1. List all files in a directory
   Command: find .

2. Search for files with maxdepth
   Command: find /etc -maxdepth 1 -name "*.sh"

3. Search for files with a specific name
   Command: find ./test -type f -name "<file*>"

4. Search for directories with a specific name
   Command: find ./test -type d -name "<directory*>"

5. Search for hidden files
   Command: find ~ -type f -name ".*"

6. Search for files with specific permissions
   Command: find / -type f -perm 0740 -exec ls -la {} \\;

7. Search for SUID files
   Command: find / -perm -4000 -type f -exec ls -la {} \\;

8. Search for files belonging to a specific user
   Command: find . -user <username>

9. Search for files belonging to a specific group
   Command: find . -group <groupname>

10. Search for files modified N days ago
    Command: find / -mtime 5

11. Search for files accessed N days ago
    Command: find / -atime 5

12. Search and execute a command on found files
    Command: find / -name "*.pdf" -type f -exec ls -lah {} \\;

13. Perform a custom search
14. Back to Main Menu
"""
        print(examples)

        # Get the user's choice
        try:
            choice = int(input("Select an example to run or create your own custom search (1-14): "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 14.")
            continue

        # Map each choice to its corresponding command
        commands = {
            1: "find .",
            2: 'find /etc -maxdepth 1 -name "*.sh"',
            3: 'find ./test -type f -name "<file*>"',
            4: 'find ./test -type d -name "<directory*>"',
            5: 'find ~ -type f -name ".*"',
            6: "find / -type f -perm 0740 -exec ls -la {} \\;",
            7: "find / -perm -4000 -type f -exec ls -la {} \\;",
            8: "find . -user <username>",
            9: "find . -group <groupname>",
            10: "find / -mtime 5",
            11: "find / -atime 5",
            12: 'find / -name "*.pdf" -type f -exec ls -lah {} \\;',
        }

        # Handle user's choice
        if choice in commands:
            if "<" in commands[choice]:  # Check if the command requires user input
                print(f"Example: {commands[choice]}")
                user_input = input("Customize the placeholders (e.g., replace '<file*>' with 'myfile*'): ").strip()
                command = commands[choice].replace("<file*>", user_input).replace("<directory*>", user_input).replace("<username>", user_input).replace("<groupname>", user_input)
            else:
                command = commands[choice]

            # Execute the command
            execute_find_command(command)

        elif choice == 13:  # Custom search
            custom_command = input("Enter your custom 'find' command: ").strip()
            execute_find_command(custom_command)

        elif choice == 14:  # Back to Main Menu
            print("Returning to Main Menu...")
            return

        else:
            print("Invalid choice. Please select a valid option.")

        input("\nPress ENTER to continue...")

# Run the main function when the script is executed directly
if __name__ == "__main__":
    """
    LESSON: What does 'if __name__ == "__main__":' do?
    
    - In Python, every file (module) has a special variable called `__name__`.
    - When a file is executed directly, its `__name__` is set to `"__main__"`.
    - If the file is imported into another script, its `__name__` is set to the filename instead.
    
    Why use this?
    - It ensures that certain parts of the code (like the `main()` function) are only executed
      when the script is run directly, not when it's imported as a module.
    - This is a best practice for Python scripts, as it allows the file to serve both as an
      independent program and as a reusable module.
    
    Example:
    1. Run the script directly:
       $ python script.py
       - `__name__` will be `"__main__"`, and the `main()` function will be executed.

    2. Import the script:
       from script import some_function
       - `__name__` will NOT be `"__main__"`, so the `main()` function will NOT run.
    """
    # Check if the requirements are met
    #if check_requirements():
    #print("[INFO] All requirements are met. Starting the script...")
    main()  # Call the main function to begin the program
    #else:
        #print("[ERROR] Please fix the above issues and rerun the script.")

