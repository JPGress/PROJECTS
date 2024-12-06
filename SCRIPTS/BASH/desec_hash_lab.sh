#!/bin/bash

# Verifica se o número correto de parâmetros foi fornecido
if [ $# -ne 2 ]; then
    echo "Uso: $0 <hash_sha1> <wordlist>"
    exit 1
fi

# Atribui os parâmetros a variáveis
hash_recebido=$1
wordlist=$2

# Verifica se o arquivo da wordlist existe
if [ ! -f "$wordlist" ]; then
    echo "O arquivo de wordlist '$wordlist' não foi encontrado."
    exit 1
fi

# Processa cada palavra na wordlist
while IFS= read -r palavra; do
    # Gera o hash MD5 da palavra
    hash_md5=$(echo -n "$palavra" | md5sum | awk '{print $1}')
    # Codifica o hash MD5 em Base64
    base64_md5=$(echo -n "$hash_md5" | base64)
    # Codifica o hash base64 em sha1
    hash_sha1=$(echo -n "$base64_md5" | shasum -a 1 | awk '{print $1}')
    # Compara o hash SHA1 com o fornecido
    if [ "$hash_recebido" == "$hash_sha1" ]; then
        echo "Palavra encontrada: $palavra"
        exit 0
    fi
    # Exibe o resultado
    echo "$hash_sha1"
done < "$wordlist"
