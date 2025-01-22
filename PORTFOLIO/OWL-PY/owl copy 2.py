#!/usr/bin/env python
"""
owl.py - Secure Python CLI replacing owl.sh
"""

#todo ADD HEADER
#todo: CONFIGURE PROXY CHAINS WHEN INITIALIZING THE SCRIPT

# Import sections
import argparse
import subprocess
import sys
import os
import socket
import re
import requests
import whois
import dns.resolver
import webbrowser
import time
from datetime import datetime, timezone
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from urllib.parse import quote

# Define the top 1,000 most common ports (similar to Nmap's default)
COMMON_PORTS = list(range(1, 1025)) + [
    3306, 3389, 5900, 8080, 8443, 10000, 5000, 6379, 27017
]  # Add additional commonly scanned ports here

"""
AUXILIARY FUNCTIONS
"""
def pause():
    input("Press Enter to continue...")

# Function for extracting subdomains from a webpage
def extract_subdomains(site):
    try:
        response = requests.get(site)
        html_content = response.text
        subdomains = re.findall(r'https?://([A-Za-z0-9.-]+)', html_content)
        return sorted(set(subdomains))
    except requests.RequestException as e:
        print(f"Error fetching URL {site}: {e}")
        return []

# Function for resolving subdomain IPs
def resolve_ip(subdomain):
    try:
        answers = dns.resolver.resolve(subdomain, 'A')
        return [answer.to_text() for answer in answers]
    except Exception as e:
        return [f"Error resolving IP for {subdomain}: {e}"]

# Function for fetching WHOIS information
def fetch_whois(domain):
    try:
        whois_info = whois.whois(domain)
        return whois_info.text if whois_info else "No WHOIS information available."
    except Exception as e:
        return f"Error fetching WHOIS for {domain}: {e}"

# Function for running DNS lookup
def dns_lookup(domain):
    try:
        resolver = dns.resolver.Resolver()
        resolver.timeout = 5
        resolver.lifetime = 5
        answers = resolver.resolve(domain, 'A')
        return ", ".join([str(answer) for answer in answers])
    except Exception as e:
        return f"Error performing DNS lookup for {domain}: {e}"

def menu_google_hacking():
    """Prompt the user to enter the target name."""
    target_gh = input("Enter the name of the target to search: ")
    return target_gh

def pesquisa_geral(target_gh):
    print("Searching WEBMII server...")
    webbrowser.open(f'https://webmii.com/people?n="{target_gh}"')

    print("Searching all over Google...")
    webbrowser.open(f'https://www.google.com/search?q=intext:"{target_gh}"')

def pesquisa_arquivo(target_gh, file_type, extensao):
    """Search for specific file types."""
    print(f'Searching for file type: {file_type}')
    webbrowser.open(f'https://www.google.com/search?q=filetype:"{extensao}"+intext:"{target_gh}"')

def pesquisar_site(target_gh, site, domain_gh):
    """Search within a specific site."""
    print(f"Searching in {site}")
    webbrowser.open(f'https://www.google.com/search?q=inurl:"{domain_gh}"+intext:"{target_gh}"')

def validate_url(url):
    return url.startswith("http") and "." in url
"""
MAIN MENU FUNCTION
"""
def texto_main_menu():
    """
    Main menu display function.
    """
    # Clear the screen (compatible with Windows and Unix)
    os.system('cls' if os.name == 'nt' else 'clear')

    # Print the menu header
    
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

        # Menu options
    options = [
            "Portscan",
            "Parsing HTML",
            "Google Hacking",
            "Metadata analysis",
            "DNS Zone Transference",
            #"SubDomain Take Over",
            #"DNS reverse",
            #"DNS recon",
            #"OSINTool",
            #"MiTM",
            #"Portscan (bash sockets)",
            #"Useful commands for network management",
            #"Examples of the find command",
            #"Debian root password change memo",
            #"Red Hat root password change memo",
            #"Vim usage memento",
            #"rbash escaping techniques (function under test)",
            #"Wireless Network Attacks",
            #"Windows Tip Reminders",
            #"NMAP Network Scanner",
            #"xxxxx",
            #"xxiv_revshell_windows",
            #"xxv_rdp_windows"
            ]

    # Print menu options
    for i, option in enumerate(options, 1):
        print(f"{i} - {option}")
    print("+==============================================+")
    print(" Enter 0(zero) to exit")
    print("+==============================================+")

    # User input
    choice = input("Enter option number: ").strip()
    return choice

"""
MAIN FUNCTION 
"""
def main():
    parser = argparse.ArgumentParser(
        description="Owl is a Python-based CLI tool designed for streamlined automation of system operations and security tasks."
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Increase output verbosity."
    )

    args = parser.parse_args()

    while True:
        choice = texto_main_menu()

        if choice == "0":
            print("Exiting Owl. Goodbye!")
            break
        
        #Call i_port_scan function
        elif choice == "1":
            target_ip = input("Enter target IP or hostname: ").strip()
            start_port = input("Enter the starting port (or leave blank for default): ").strip()
            end_port = input("Enter the ending port (or leave blank for default): ").strip()
            verbose_choice = input("Verbose output? (yes/no, default no): ").strip().lower()
            verbose = verbose_choice in ["yes", "y"]

            # Convert ports to integers if specified, otherwise default to None
            start_port = int(start_port) if start_port else None
            end_port = int(end_port) if end_port else None

            # Call the scanning function
            result_file = i_port_scan(target_ip, start_port, end_port, verbose)
            print(f"Results stored in: {result_file}")
        
        # Call ii_parsin_scan function
        elif choice == "2":
            ii_parsing_html()
        
        # Call iii_google_hacking function
        elif choice == "3":
            iii_google_hacking()
        
        elif choice == "4":
            iv_metadata_analysis()
        
        elif choice == "5":    
            print("Option 5 selected.")
        # Add more elif branches for each menu option
        else:
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
    def scan_port(port):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
                sock.settimeout(1)
                result = sock.connect_ex((target, port))
                if result == 0:
                    if verbose:
                        print(f"Port {port}: OPEN")
                    return port
        except Exception as e:
            if verbose:
                print(f"[ERROR] Port {port} scan failed: {e}")
        return None

    # Determine the port range
    ports_to_scan = range(start_port, end_port + 1) if start_port and end_port else COMMON_PORTS
    print(f"Scanning target {target} on ports: {', '.join(map(str, ports_to_scan[:10]))}... (and more)")

    open_ports = []

    # Multithreading for scanning ports
    with ThreadPoolExecutor(max_workers=50) as executor:
        futures = {executor.submit(scan_port, port): port for port in ports_to_scan}
        for future in futures:
            port_result = future.result()
            if port_result:
                open_ports.append(port_result)

    # Generate timestamped filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"scan_{timestamp}.txt"

    # Write results to file
    with open(filename, "w") as file:
        file.write(f"Scan Report for {target}\n")
        file.write(f"Scanned Ports: {start_port or 'N/A'}-{end_port or 'Top 1k Common Ports'}\n")
        file.write("Open Ports:\n")
        if open_ports:
            for port in open_ports:
                file.write(f"- Port {port}: OPEN\n")
        else:
            file.write("No open ports found.\n")

    print(f"[INFO] Scan completed. Results saved to {filename}")
    pause()  # Pause and wait for user input
    print("Continuing with the script...")
    return filename

def ii_parsing_html():
    site = input("Enter the URL of the site to analyze: ").strip()
    now = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    output_file = f"result_{now}.txt"
    
    with open(output_file, 'w') as output:
        output.write(f"Report generated on: {now}\n\n")
        subdomains = extract_subdomains(site)

        if not subdomains:
            print(f"No subdomains found for: {site}")
            output.write(f"No subdomains found for: {site}\n")
        else:
            print(f"Found subdomains for {site}:")
            for subdomain in subdomains:
                print(f"Analyzing: {subdomain}")
                output.write(f"Subdomain: {subdomain}\n")
                
                ips = resolve_ip(subdomain)
                output.write(f"IP Addresses: {', '.join(ips)}\n")
                
                whois_data = fetch_whois(subdomain)
                output.write(f"WHOIS Info:\n{whois_data}\n")
                
                dns_info = dns_lookup(subdomain)
                output.write(f"DNS Lookup: {dns_info}\n")
                
                output.write("\n")
    
    print(f"Analysis complete. Results saved in: {output_file}")
    pause()
    print("Continuing with the script...")

def iii_google_hacking():
    """Main function to perform Google hacking."""
    target_gh = menu_google_hacking()
    pesquisa_geral(target_gh)

    tipos = ["PDF", "ppt", "Doc", "Docx", "xls", "xlsx", "ods", "odt", "TXT", "PHP", "XML", "JSON", "PNG", "SQLS", "SQL"]
    extensoes = ["pdf", "ppt", "doc", "docx", "xls", "xlsx", "ods", "odt", "txt", "php", "xml", "json", "png", "sqls", "sql"]

    for file_type, extensao in zip(tipos, extensoes):
        pesquisa_arquivo(target_gh, file_type, extensao)

    sites = ["Governo", "Pastebin", "Trello", "Github", "LinkedIn", "Facebook", "Twitter", "Instagram", "TikTok", "youtube", "Medium", "Stack Overflow", "Quora", "Wikipedia"]
    dominios = [".gov.br", "pastebin.com", "trello.com", "github.com", "linkedin.com", "facebook.com", "twitter.com", "instagram.com", "tikTok.com", "youtube.com", "medium.com", "stackoverflow.com", "quora.com", "wikipedia.org"]

    for site, domain_gh in zip(sites, dominios):
        pesquisar_site(target_gh, site, domain_gh)

    pause()

def iv_metadata_analysis():
    # Define the base search command
    SEARCH = "lynx -dump -hiddenlinks=merge -force_html"

    def menu_metadata_analysis():
        # Prompt the user for input
        SITE = input("Enter the extension of the URL where you want to search (Ex:.gov.br): ").strip()
        FILE = input("Enter the extension of the file you want to search (Ex: .pdf): ").strip()
        KEYWORD = input("[optional] Enter a keyword to help with the search (Ex: vaccine): ").strip()
        return SITE, FILE, KEYWORD

    def search(SITE, FILE, KEYWORD):
        # Construct and encode the query URL
        query = f"inurl:{SITE} filetype:{FILE}"
        if KEYWORD:
            query += f" intext:{KEYWORD}"
        query = quote(query)
        search_url = f"https://www.google.com/search?q={query}"

        print(f"Performing search with query: {search_url}")

        # Generate filename for results
        timestamp = datetime.now(timezone.utc).strftime('%d%H%M%b%Y')
        filename = f"{timestamp}-UTC_{SITE}_{KEYWORD if KEYWORD else ''}_{FILE}_filtered.txt"

        try:
            # Execute search command
            command = f"lynx -dump -hiddenlinks=merge -force_html \"{search_url}\" | grep -i '\\.{FILE[1:]}' | cut -d '=' -f2 | grep -v 'x-raw-image' | sed 's/...$//' > {filename}"
            subprocess.run(command, shell=True, check=True)

            # Validate results before download
            with open(filename, 'r') as f:
                urls = [line.strip() for line in f if validate_url(line.strip())]

            if urls:
                download(urls, SITE)
            else:
                print("No valid URLs found.")
        except Exception as e:
            print(f"Error during search: {e}")

    def download(urls, SITE):
        folder = f"{SITE}_{datetime.now(timezone.utc).strftime('%d%H%M%b%Y')}-UTC"
        os.makedirs(folder, exist_ok=True)

        for url in urls:
            try:
                subprocess.run(["wget", "-P", folder, url], check=True)
            except subprocess.CalledProcessError:
                print(f"Failed to download: {url}")

    def read_metadate(folder):
        # Extract metadata from downloaded files
        os.chdir(folder)
        subprocess.run(["exiftool", "./*"], check=True)

    # Gather inputs
    SITE, FILE, KEYWORD = menu_metadata_analysis()
    # Perform the search and process results
    search(SITE, FILE, KEYWORD)

    pause()

# Run the main function when the script is executed directly
if __name__ == "__main__":
    main()
