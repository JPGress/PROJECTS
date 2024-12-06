#!/usr/bin/env python3


from Cryptodome.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import base64
import os

# Função para criptografar o arquivo
def encrypt_file(file_path, key, output_path):
    cipher = AES.new(key, AES.MODE_CBC)
    with open(file_path, 'rb') as f:
        data = f.read()
    ciphertext = cipher.encrypt(pad(data, AES.block_size))
    iv = cipher.iv
    encrypted_data = base64.b64encode(iv + ciphertext)

    with open(output_path, 'wb') as f:
        f.write(encrypted_data)

    print(f"Arquivo criptografado salvo em: {output_path}")

# Função para descriptografar o arquivo
def decrypt_file(encrypted_file_path, key, output_path):
    with open(encrypted_file_path, 'rb') as f:
        encrypted_data = base64.b64decode(f.read())

    iv = encrypted_data[:AES.block_size]
    ciphertext = encrypted_data[AES.block_size:]

    cipher = AES.new(key, AES.MODE_CBC, iv)
    original_data = unpad(cipher.decrypt(ciphertext), AES.block_size)

    with open(output_path, 'wb') as f:
        f.write(original_data)

    print(f"Arquivo descriptografado salvo em: {output_path}")

if __name__ == "__main__":
    print("Bem-vindo ao programa de criptografia Moriarty!")
    print("Escolha uma opção:")
    print("1. Criptografar um arquivo")
    print("2. Descriptografar um arquivo")

    choice = input("Digite sua escolha (1 ou 2): ")

    if choice == '1':
        file_path = input("Digite o caminho do arquivo para criptografar: ")
        output_path = input("Digite o caminho para salvar o arquivo criptografado: ")
        key = input("Digite uma chave (16 caracteres): ").encode()
        if len(key) != 16:
            print("Erro: a chave deve ter 16 caracteres!")
        else:
            encrypt_file(file_path, key, output_path)

    elif choice == '2':
        encrypted_file_path = input("Digite o caminho do arquivo criptografado: ")
        output_path = input("Digite o caminho para salvar o arquivo descriptografado: ")
        key = input("Digite a chave de descriptografia (16 caracteres): ").encode()
        if len(key) != 16:
            print("Erro: a chave deve ter 16 caracteres!")
        else:
            decrypt_file(encrypted_file_path, key, output_path)

    else:
        print("Opção inválida! Saindo...")
