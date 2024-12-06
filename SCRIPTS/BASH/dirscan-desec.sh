#!/bin/bash
#todo: IMPLEMENTAR NO 0wl.sh

feroxbuster -A --url "$1" -x php aspx jsp html js txt jpg jpeg png zip 7zip rar -w "$2" -o "$3"

#LISTA_USER_AGENT=(
#    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" #Safari
#    "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15" #Safari
#	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" #Google Chrome
#	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" #Google Chrome
#	"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:53.0) Gecko/20100101 Firefox/53.0)" #Mozilla Firefox
#	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393" #Microsoft Edge
#	"Mozilla/5.0 (iPad; CPU OS 8_4_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H321 Safari/600.1.4" #Apple iPad
#	"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1" #Apple iPhone
#	"Mozilla/5.0 (Linux; Android 6.0.1; SAMSUNG SM-N910F Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/4.0 Chrome/44.0.2403.133 Mobile Safari/537.36" #Samsung Galaxy Note 4
#
#)
#
#URL="https://ifconfig.me/ua"
#for i in {1..3}
#	do
#		RANDOM_INDEX=$(( RANDOM % ${#LISTA_USER_AGENT[@]} ))
#		USER_AGENT="${LISTA_USER_AGENT[RANDOM_INDEX]}"
#	    curl -A "$USER_AGENT" "$URL" -w "\n"
#		echo ""
#	done
#
#
#for diretorio in $(cat /media/r3v4n/R3v4N64/CyberVault/EXTRAS/WORDLISTS/dir_ptbr_eng.0wl.txt); do
#	RANDOM_INDEX=$(( RANDOM % ${#LISTA_USER_AGENT[@]} ))
#	USER_AGENT="${LISTA_USER_AGENT[RANDOM_INDEX]}"
#	resposta=$(curl --user-agent "$USER_AGENT" -s -p /dev/null -w "%{http_code}" "$1"/"$diretorio"/)
#	if [ "$resposta" == "200" ]; then
#		echo "Diretório encontrado: $1/$diretorio"
#	fi
#done
#
##URL=$1
##for i in {1..5}
##do
##	RANDOM_INDEX=$(( RANDOM % ${#LISTA_USER_AGENT[@]} ))
##	USER_AGENT="${LISTA_USER_AGENT[RANDOM_INDEX]}"
##    curl -A "$USER_AGENT" "$URL" -w "\n"
##done