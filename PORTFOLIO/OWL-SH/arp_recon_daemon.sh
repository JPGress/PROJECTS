#!/bin/bash

# ==============================
# ARP Recon Daemon - Passive Network Monitoring
# Author: R3v4N's 0wL
# Version: 1.0
# Description: Monitors ARP changes and logs new/removed devices.
# ==============================

# === CONFIGURATION ===
KNOWN_HOSTS_FILE="/tmp/arp_known_hosts.txt"
NETWORK_RANGE="192.168.1.0/24"   # Change to match the target network
INTERFACE="eth0"                 # Adjust to match the correct network interface
LOG_FILE="/var/log/arp_recon.log"
SLEEP_TIME=30                     # Time in seconds between scans

# === FUNCTION: Initialize Log File ===
function init_log() {
    if [[ ! -f "$LOG_FILE" ]]; then
        touch "$LOG_FILE"
        echo "[*] $(date) - ARP Recon Daemon Started" >> "$LOG_FILE"
    fi
}

# === FUNCTION: Scan Network for Active Hosts ===
function scan_network() {
    sudo arp-scan -x -I "$INTERFACE" "$NETWORK_RANGE" 2>/dev/null | awk '{print $1}' | sort -u
}

# === FUNCTION: Monitor ARP Changes ===
function monitor_arp() {
    echo "[*] $(date) - ARP Recon Daemon is now monitoring $NETWORK_RANGE on $INTERFACE"
    while true; do
        # Perform ARP scan
        NEW_SCAN=$(scan_network)

        # Detect new hosts
        for host in $NEW_SCAN; do
            if ! grep -q "$host" "$KNOWN_HOSTS_FILE"; then
                echo "[+] $(date) - New Host Detected: $host" | tee -a "$LOG_FILE"
                echo "$host" >> "$KNOWN_HOSTS_FILE"
                # Optionally, trigger an alert here (email, webhook, etc.)
            fi
        done

        # Detect removed hosts
        for host in $(cat "$KNOWN_HOSTS_FILE"); do
            if ! echo "$NEW_SCAN" | grep -q "$host"; then
                echo "[-] $(date) - Host Disconnected: $host" | tee -a "$LOG_FILE"
                sed -i "/$host/d" "$KNOWN_HOSTS_FILE"
            fi
        done

        sleep "$SLEEP_TIME"
    done
}

# === FUNCTION: Start Daemon Process ===
function start_daemon() {
    init_log
    monitor_arp &
    echo "[*] ARP Recon Daemon started in background (PID: $!)"
}

# === RUN DAEMON ===
start_daemon
