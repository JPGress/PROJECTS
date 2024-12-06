#!/usr/bin/env python3
# -*- coding: utf-8 -*-
################################################################
#Criador de Wordlist - Contexto Brasileiro
#----------------------------------------------------------------
#Descrição:
#    Este script gera uma wordlist personalizada baseada em elementos culturais brasileiros, como futebol, animais, música, e informações pessoais.
#    É útil para pentests e atividades que exigem uma wordlist específica do contexto brasileiro.
#
#Versão:
#    0.1.2
#
#Autor:
#    R3v4N|0.0wL
#
#Data de Criação:
#    2024-12-05
#
#Dependências:
#    - itertools (nativo do Python)
#    - os (nativo do Python)
#    - unicodedata (nativo do Python)
#
#Funções:
#    - remover_acentuacao(texto): Remove acentuação dos caracteres em uma string.
#    - wordlist_generator(...): Gera a wordlist personalizada e a salva em um arquivo.
#
#Uso:
#    Execute o script e insira as informações solicitadas para gerar a wordlist.
#
#Histórico:
# 0.0.1 -> Primeiro código funcional para gerar a wordlist personalizada
# 0.0.2 -> Alterado o nome do arquivo gerado
# 0.0.3 -> 
########################################################################

import itertools
import os
import unicodedata

# Limpa a tela antes de começar
os.system('cls' if os.name == 'nt' else 'clear')

import itertools
import os
import unicodedata

def remover_acentuacao(texto):
    # Substituir 'ç' por um marcador temporário
    texto = texto.replace('ç', '__CEDILLA__')
    # Normalizar o texto
    texto = unicodedata.normalize('NFD', texto)
    # Substituir 'c' + cedilha combinante pelo marcador temporário
    texto = texto.replace('ç', '__CEDILLA__')
    # Remover sinais diacríticos
    texto = ''.join(c for c in texto if unicodedata.category(c) != 'Mn')
    # Restaurar o 'ç' a partir do marcador temporário
    texto = texto.replace('__CEDILLA__', 'ç')
    return texto

def wordlist_generator(nome, sobrenome, apelido, cidade, clube_futebol, animal_favorito, banda, ano_nascimento, ano_importante):
    palavras = []

    # Informações pessoais
    nome = remover_acentuacao(nome)
    sobrenome = remover_acentuacao(sobrenome)
    apelido = remover_acentuacao(apelido)
    cidade = remover_acentuacao(cidade)
    clube_futebol = remover_acentuacao(clube_futebol)
    animal_favorito = remover_acentuacao(animal_favorito)
    banda = remover_acentuacao(banda)

    palavras.append(nome)
    palavras.append(sobrenome)
    palavras.append(apelido)
    palavras.append(cidade)
    palavras.append(clube_futebol)
    palavras.append(animal_favorito)
    palavras.append(banda)
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
    nome_arquivo = f"wordlist_{nome}_{sobrenome}.txt"
    with open(nome_arquivo, 'w') as file:
        for word in wordlist:
            file.write(word + '\n')

    print(f"Wordlist gerada com {len(wordlist)} palavras e salva em '{nome_arquivo}'")

if __name__ == "__main__":
    print("Criador de Wordlist - Contexto Brasileiro")
    nome = input("Digite o primeiro nome: ")
    sobrenome = input("Digite o sobrenome: ")
    apelido = input("Digite um apelido: ")
    cidade = input("Digite a cidade de origem: ")
    clube_futebol = input("Digite o clube de futebol favorito: ")
    animal_favorito = input("Digite o animal favorito: ")
    banda = input("Digite a banda ou cantor(a) favorito(a): ")
    ano_nascimento = input("Digite o ano de nascimento: ")
    ano_importante = input("Digite um ano importante (ex: casamento, formatura): ")

    wordlist_generator(nome, sobrenome, apelido, cidade, clube_futebol, animal_favorito, banda, ano_nascimento, ano_importante)
