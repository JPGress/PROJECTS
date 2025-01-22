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
from datetime import datetime, timezone  # For working with dates and timezones.
from concurrent.futures import ThreadPoolExecutor  # To perform tasks concurrently (multi-threading).
from urllib.parse import quote  # For encoding URLs.
from selenium import webdriver  # For automating web browser interactions
from selenium.webdriver.chrome.service import Service  # For managing the ChromeDriver service
from selenium.common.exceptions import WebDriverException  # For handling exceptions related to WebDriver operations
from selenium.webdriver.common.by import By  # For locating elements in Selenium
from selenium.webdriver.chrome.options import Options  # For configuring Chrome browser options

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
        # "DNS recon",
        # "OSINTool",
        # "MiTM",
        # "Portscan (bash sockets)",
        # "Useful commands for network management",
        # "Examples of the find command",
        # "Debian root password change memo",
        # "Red Hat root password change memo",
        # "Vim usage memento",
        # "rbash escaping techniques (function under test)",
        # "Wireless Network Attacks",
        # "Windows Tip Reminders",
        # "NMAP Network Scanner",
        # "xxxxx",
        # "xxiv_revshell_windows",
        # "xxv_rdp_windows"
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
            print("[WARNING] Metadata analysis requires Selenium. This function is unstable")
            pause()
            iv_metadata_analysis()

        elif choice == "5":  # Reserved for future functionality
            v_dns_zt()
            
        elif choice == "6":  # Subdomain Takeover
            vi_subdomain_takeover()
        
        elif choice == "7":  # DNS reverse
            print("[WARNING] This function is not implemented yet")
            pause()
            vii_dns_reverse()
            
        #elif choice == "8":  # Reserved for future functionality
        
        #elif choice == "9":  # Reserved for future functionality
        
        #elif choice == "10":  # Reserved for future functionality
        
        #elif choice == "11":  # Reserved for future functionality
        
        #elif choice == "12":  # Reserved for future functionality
        
        #elif choice == "13":  # Debian root password change memo
        
        #elif choice == "14":  # Red Hat root password change memo
        
        #elif choice == "15":  # Vim usage memento
        
        #elif choice == "16":  # rbash escaping techniques
        
        #elif choice == "17":  # Wireless Network Attacks
        
        #elif choice == "18":  # Windows Tip Reminders
        
        #elif choice == "19":  # NMAP Network Scanner
        
        #elif choice == "20":  # xxxxx
        
        #elif choice == "21":  # xxiv_revshell_windows

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

def vii_dns_reverse():
    print("vii_dns_reverse()")

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

