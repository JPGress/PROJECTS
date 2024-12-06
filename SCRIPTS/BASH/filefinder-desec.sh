#!/bin/bash
#todo: IMPLEMENTAR NO 0wl.sh
lynx -dump https://www.google.com/search?q=inurl:"$1"+filetype:"$2" | cut -d= -f2 | grep ".$2" | grep -E -v "inurl" | sed -e s'/...$//'g