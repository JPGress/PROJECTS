#!/bin/bash
##############################################################
#
#       02-ScannAP.sh - Start a Scann an AP target
#
#           AUTHOR: Z1GN1F3R =D
#
#           DATE: 01-27-2021
#   
#           DESCRIPTION: 
#
#
##############################################################

#$MACTARGET=$1
#$CHANNEL=$2

#Welcome
    clear
    echo"--- HELLO FRIEND ---"

#Scanning the AP target

    airodump-ng mon0 --bssid $1 -c $2 --write log-02-ScannAP

#Show the results
    clear
    echo "--- RESULTS ---"
    ls -1 log-02-ScannAP*
    echo "--- END ---"
