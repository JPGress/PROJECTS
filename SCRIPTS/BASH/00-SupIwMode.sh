#!/bin/bash
############################### 00-SupIwMode.sh ###############################
#
#   AUTHOR: Z1GN1F3R 
#   DATE: 01-27-2021
#   
#   DESCRIPTION:
#
##############################################################################

#Code
clear
echo ""
echo "########## SUPPORTED INTERFACES ##########"
airmon-ng
echo "-------------------------------------------------"
iw list | grep -iA10 "supported interface modes"
echo ""
echo "########## END ##########"
