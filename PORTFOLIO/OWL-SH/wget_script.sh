#!/bin/bash

while IFS= read -r URL; do
    wget --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0" -P ./pasta_teste "$URL"
done < wget_test.log

