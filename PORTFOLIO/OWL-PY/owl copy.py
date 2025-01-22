#!/usr/bin/env python
"""
owl.py - Secure Python CLI replacing owl.sh
"""

import argparse
import subprocess
import sys
import os

def main():
    parser = argparse.ArgumentParser(
        description = "Owl is a Python-based CLI tool designed for streamlined automation of system operations and security tasks. It combines simplicity and flexibility to manage file encryption, process handling, network diagnostics, and scripting utilities. With its intuitive commands, Owl empowers users to efficiently perform routine tasks and enhances system security workflows, making it an ideal tool for developers, system administrators, and cybersecurity professionals."
    
    )

    # Example argument: "scan" command
    parser.add_argument(
        "scan",
        nargs="?",
        help="Run a security scan on a target host (e.g., network or local resources)."
    )

    # Example flag: --verbose
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Increase output verbosity."
    )

    args = parser.parse_args()

    if args.scan:
        # Call your scanning function or run a command
        run_scan(target=args.scan, verbose=args.verbose)
    else:
        parser.print_help()

def run_scan(target, verbose=False):
    """
    Replace your Bash scanning logic with Python equivalents.
    For demonstration, let's run an Nmap command in a safer manner.
    """
    try:
        if verbose:
            print(f"[INFO] Scanning {target} with nmap...")

        # WARNING: If 'target' is user input, sanitize or validate it thoroughly.
        # Attackers could try injection if used directly in a shell command!
        # Safest approach is to avoid shell=True and pass arguments as a list:

        subprocess.run(["nmap", "-sV", target], check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Scan failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
