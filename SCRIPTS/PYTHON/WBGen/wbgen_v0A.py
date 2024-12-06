#!/usr/bin/env python3
import itertools
import os

# Limpa a tela antes de começar
os.system('cls' if os.name == 'nt' else 'clear')

def wordlist_generator(nome, sobrenome, apelido, cidade, clube_futebol, animal_favorito, bandas, ano_nascimento, ano_importante):
    palavras = []

    # Informações pessoais
    palavras.append(nome)
    palavras.append(sobrenome)
    palavras.append(apelido)
    palavras.append(cidade)
    palavras.append(clube_futebol)
    palavras.append(animal_favorito)
    palavras.append(bandas)
    palavras.append(str(ano_nascimento))
    palavras.append(str(ano_importante))

    # Combinações de informações pessoais
    combinacoes_basicas = list(itertools.permutations(palavras, 2))
    for combinacao in combinacoes_basicas:
        palavras.append(''.join(combinacao))

    # Adiciona variações com números e caracteres especiais
    palavras_com_variacoes = []
    caracteres_especiais = ['!', '@', '#', '$', '%', '&']
    for palavra in palavras:
        palavras_com_variacoes.append(palavra)
        for char in caracteres_especiais:
            palavras_com_variacoes.append(palavra + char)
            palavras_com_variacoes.append(char + palavra)
        for i in range(10):
            palavras_com_variacoes.append(palavra + str(i))
            palavras_com_variacoes.append(str(i) + palavra)

    # Remove duplicatas
    wordlist = list(set(palavras_com_variacoes))

    # Salva em um arquivo
    with open('wordlist_brasileira.txt', 'w') as file:
        for word in wordlist:
            file.write(word + '\n')

    print(f"Wordlist gerada com {len(wordlist)} palavras e salva em 'wordlist_brasileira.txt'")

if __name__ == "__main__":
    print("Gerador de Wordlist Brasileira")
    nome = input("Digite o primeiro nome: ")
    sobrenome = input("Digite o sobrenome: ")
    apelido = input("Digite um apelido: ")
    cidade = input("Digite a cidade de origem: ")
    clube_futebol = input("Digite o clube de futebol favorito: ")
    animal_favorito = input("Digite o animal favorito: ")
    bandas = input("Digite as bandas ou cantores favoritos: ")
    ano_nascimento = input("Digite o ano de nascimento: ")
    ano_importante = input("Digite um ano importante (ex: casamento, formatura): ")

    wordlist_generator(nome, sobrenome, apelido, cidade, clube_futebol, animal_favorito, bandas, ano_nascimento, ano_importante)
