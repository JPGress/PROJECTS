#!/bin/bash



        USER_AGENTS=(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5414.119 Safari/537.36"
            "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.5359.124 Safari/537.36"
            "Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5414.119 Mobile Safari/537.36"
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.5414.119 Safari/537.36 Edg/109.0.774.68"
        )

        FOLDER="pasta_temp"
        mkdir -p "$FOLDER"
        while IFS= read -r URL; do
            RANDOM_USER_AGENT="${USER_AGENTS[RANDOM % ${#USER_AGENTS[@]}]}"
            echo -e "Downloading file with ${RANDOM_USER_AGENT}"  # Log the download URL
            wget --user-agent="$RANDOM_USER_AGENT" -P "$FOLDER" "$URL"
        done < $1
        #rm -f "$FILE_LIST"  # Clean up the temporary results file


