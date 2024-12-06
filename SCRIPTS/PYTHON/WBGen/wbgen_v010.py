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
# 0.1.0 -> Cores no texto; alterada a estrutura de entrada de dados e de saída no main() com o uso de arrays; funçãos adicionada: processar_input, formatar_mes, formatar_mes;
########################################################################

import itertools
import os
import unicodedata

# Definição das cores ANSI
RED = '\033[0;91m'
WHITE = '\033[37m'
RESET = '\033[0m'

# Limpa a tela antes de começar
os.system('cls' if os.name == 'nt' else 'clear')

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

def processar_input(texto):
    # Remove acentuação
    texto = remover_acentuacao(texto)
    # Substitui vírgulas por espaços
    texto = texto.replace(',', ' ')
    # Divide o texto em palavras
    palavras = texto.split()
    # Remove palavras vazias e espaços extras
    palavras = [palavra.strip() for palavra in palavras if palavra.strip()]
    return palavras

def formatar_mes(mes):
    meses = {
        "1": "janeiro", "2": "fevereiro", "3": "marco", "4": "abril",
        "5": "maio", "6": "junho", "7": "julho", "8": "agosto",
        "9": "setembro", "10": "outubro", "11": "novembro", "12": "dezembro"
    }
    return meses.get(mes.zfill(2), mes)

def formatar_data(data, abreviar_mes=False):
    
    #Formata uma data no formato DDMMAA ou DDMMAAAA,
    #substituindo o mês numérico pelo nome do mês por extenso ou abreviado.

    #Parâmetros:
    #- data (str): Data no formato DDMMAA ou DDMMAAAA.
    #- abreviar_mes (bool): Se True, utiliza abreviação de três letras para o mês.

    #Retorna:
    #- str: Data formatada com o mês por extenso ou abreviado.
    
    meses = {
        "01": "janeiro",   "02": "fevereiro", "03": "marco",   "04": "abril",
        "05": "maio",      "06": "junho",     "07": "julho",   "08": "agosto",
        "09": "setembro",  "10": "outubro",   "11": "novembro","12": "dezembro"
    }
    if len(data) == 6 or len(data) == 8:
        dia_str, mes_str, ano = data[:2], data[2:4], data[4:]
        if mes_str in meses:
            mes_nome = meses[mes_str]
            dia = int(dia_str)
            mes = int(mes_str)
            dias_no_mes = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
            if 1 <= dia <= dias_no_mes[mes - 1]:
                if abreviar_mes:
                    mes_nome = mes_nome[:3]
                return f"{dia_str}{mes_nome}{ano}"
            else:
                return data
        else:
            return data
    else:
        return data

def obter_entradas_basicas():
    entradas_basicas = []
    
    # nome
    nome_input = input(f"{RED}Nome da pessoa-alvo (para nome composto use espaço, ex: 'Harry Potter'; para vários use vírgula, ex: 'Harry, Potter'): {WHITE}")
    print(f"{RESET}", end='')
    nomes = [remover_acentuacao(nome.strip()) for nome in nome_input.split(',') if nome.strip()]
    entradas_basicas.extend(nomes)

    # sobrenome
    sobrenome_input = input(f"{RED}Sobrenome(s) da pessoa-alvo (para vários, separe por vírgula, ex: 'Silva, Souza'): {WHITE}")
    print(f"{RESET}", end='')
    sobrenomes = [remover_acentuacao(sobrenome.strip()) for sobrenome in sobrenome_input.split(',') if sobrenome.strip()]
    entradas_basicas.extend(sobrenomes)
    
    # apelido
    apelido_input = input(f"{RED}Apelido da pessoa-alvo (se houver, separe múltiplos por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    apelidos = processar_input(apelido_input)
    entradas_basicas.extend(apelidos)

    # Signo
    signo_input = input(f"{RED}Signo da pessoa-alvo (ex: Áries, Touro): {WHITE}")
    print(f"{RESET}", end='')
    signo = processar_input(signo_input)
    entradas_basicas.extend(signo)

    # Cor preferida
    cor_preferida_input = input(f"{RED}Cor preferida da pessoa-alvo (se múltiplas, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    cores_preferidas = processar_input(cor_preferida_input)
    entradas_basicas.extend(cores_preferidas)

    # ano nascimento
    ano_nascimento = input(f"{RED}Ano de nascimento (ex: 1990): {WHITE}").strip()
    print(f"{RESET}", end='')
    
    # mes nascimento
    mes_nascimento_input = input(f"{RED}Mês de nascimento (1-12): {WHITE}").strip()
    print(f"{RESET}", end='')
    mes_nascimento = formatar_mes(mes_nascimento_input)
    
    # dia nascimento
    dia_nascimento = input(f"{RED}Dia de nascimento (1-31): {WHITE}").strip()
    print(f"{RESET}", end='')

    entradas_basicas.extend([ano_nascimento, mes_nascimento_input.zfill(2), mes_nascimento, dia_nascimento.zfill(2)])

    # Criar datas de nascimento
    data_nascimento_numerica = dia_nascimento.zfill(2) + mes_nascimento_input.zfill(2) + ano_nascimento
    data_nascimento_formatada = formatar_data(data_nascimento_numerica)
    entradas_basicas.extend([data_nascimento_numerica, data_nascimento_formatada])

    # Coleta do número de telefone
    telefone = input(f"{RED}Número de telefone (apenas números, ex: 11987654321): {WHITE}").strip()
    print(f"{RESET}", end='')
    if telefone:
        telefone = ''.join(filter(str.isdigit, telefone))
        entradas_basicas.append(telefone)
        if len(telefone) >= 10:
            ddd = telefone[:2]
            numero = telefone[2:]
            entradas_basicas.extend([ddd, numero])
            entradas_basicas.extend([
                f'{ddd}{numero}', f'{numero}{ddd}',
                f'{ddd}-{numero}', f'{ddd}_{numero}', f'{ddd}.{numero}'
            ])
        else:
            entradas_basicas.append(telefone)

    # Placas de veículos
    placas_input = input(f"{RED}Placas de veículos (se houver, separe por vírgula, ex: ABC1234, XYZ9876): {WHITE}")
    print(f"{RESET}", end='')
    placas = processar_input(placas_input)
    entradas_basicas.extend(placas)

    # Nomes de empresas ou instituições
    empresas_input = input(f"{RED}Nomes de empresas ou instituições (ex: Google, UnB; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    empresas = processar_input(empresas_input)
    entradas_basicas.extend(empresas)

    # Frases ou citações preferidas
    citacoes_input = input(f"{RED}Frases, trechos de música e/ou poemas, etc (ex: A fé move montanhas; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    citacoes = processar_input(citacoes_input)
    entradas_basicas.extend(citacoes)

    # Nomes de lugares importantes
    lugares_input = input(f"{RED}Nomes de lugares importantes para o alvo (ex: São Paulo, Cristo Redentor; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    lugares = processar_input(lugares_input)
    entradas_basicas.extend(lugares)

    # Informações familiares
    nome_pai_input = input(f"{RED}Nome e/ou apelido do pai (se múltiplos nomes, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes_pai = processar_input(nome_pai_input)
    entradas_basicas.extend(nomes_pai)

    nome_mae_input = input(f"{RED}Nome e/ou apelido da mãe (se múltiplos nomes, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes_mae = processar_input(nome_mae_input)
    entradas_basicas.extend(nomes_mae)

    nome_companheiro_input = input(f"{RED}Nome e/ou apelido do companheiro(a) (se houver, separe múltiplos por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes_companheiro = processar_input(nome_companheiro_input)
    entradas_basicas.extend(nomes_companheiro)

    filhos = []
    num_filhos = int(input(f"{RED}Quantos filhos a pessoa tem? (0 se nenhum): {WHITE}"))
    print(f"{RESET}", end='')
    for i in range(num_filhos):
        print(f"{RED}Dados do filho {i + 1}:{RESET}")
        nome_filho_input = input(f"{RED}Nome do filho (se múltiplos nomes, separe por vírgula): {WHITE}")
        print(f"{RESET}", end='')
        nomes_filho = processar_input(nome_filho_input)

        apelido_filho_input = input(f"{RED}Apelido do filho (se houver, separe por vírgula): {WHITE}")
        print(f"{RESET}", end='')
        apelidos_filho = processar_input(apelido_filho_input)

        ano_nascimento_filho = input(f"{RED}Ano de nascimento do filho (ex: 2015): {WHITE}").strip()
        print(f"{RESET}", end='')
        mes_nascimento_filho_input = input(f"{RED}Mês de nascimento do filho (1-12): {WHITE}").strip()
        print(f"{RESET}", end='')
        mes_nascimento_filho = formatar_mes(mes_nascimento_filho_input)
        dia_nascimento_filho = input(f"{RED}Dia de nascimento do filho (1-31): {WHITE}").strip()
        print(f"{RESET}", end='')

        entradas_basicas.extend([ano_nascimento_filho, mes_nascimento_filho_input.zfill(2), mes_nascimento_filho, dia_nascimento_filho.zfill(2)])

        # Criar datas de nascimento dos filhos
        data_nascimento_filho_numerica = dia_nascimento_filho.zfill(2) + mes_nascimento_filho_input.zfill(2) + ano_nascimento_filho
        data_nascimento_filho_formatada = formatar_data(data_nascimento_filho_numerica)
        entradas_basicas.extend([data_nascimento_filho_numerica, data_nascimento_filho_formatada])

        filhos.extend(nomes_filho + apelidos_filho)

    entradas_basicas.extend(filhos)

    # Informações culturais
    time_futebol_input = input(f"{RED}Time de futebol preferido (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    times_futebol = processar_input(time_futebol_input)
    entradas_basicas.extend(times_futebol)

    nomes_pets_input = input(f"{RED}Nome(s) dos pets (se houver, separados por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes_pets = processar_input(nomes_pets_input)
    entradas_basicas.extend(nomes_pets)

    artista_favorito_input = input(f"{RED}Artista(s) ou banda(s) favorita(s) (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    artistas_favoritos = processar_input(artista_favorito_input)
    entradas_basicas.extend(artistas_favoritos)

    religiosa = input(f"{RED}A pessoa parece ser religiosa? (sim/nao): {WHITE}").strip()
    print(f"{RESET}", end='')
    if religiosa.lower() == "sim":
        contexto_religioso = ["Deus", "DEUS", "JESUS", "MARIA", "Jesus", "Maria", "fe"]
        entradas_basicas.extend(contexto_religioso)

    # Informações de localização
    cidade_nascimento_input = input(f"{RED}Cidade de nascimento do alvo (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    cidades_nascimento = processar_input(cidade_nascimento_input)
    entradas_basicas.extend(cidades_nascimento)

    estado_nascimento_input = input(f"{RED}Estado de nascimento do alvo (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    estados_nascimento = processar_input(estado_nascimento_input)
    entradas_basicas.extend(estados_nascimento)

    cidade_moradia_input = input(f"{RED}Cidade atual de moradia do alvo (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    cidades_moradia = processar_input(cidade_moradia_input)
    entradas_basicas.extend(cidades_moradia)

    estado_moradia_input = input(f"{RED}Estado atual de moradia do alvo (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    estados_moradia = processar_input(estado_moradia_input)
    entradas_basicas.extend(estados_moradia)

    # Datas importantes
    data_input = input(f"{RED}Data especial para o alvo ((Considere: aniversários, casamentos, títulos, formaturas, etc)formato ddmmaa ou ddmmaaaa): {WHITE}").strip()
    print(f"{RESET}", end='')
    if data_input:
        data_formatada = formatar_data(data_input)
        entradas_basicas.extend([data_input, data_formatada])

    for _ in range(3):  # Limitar a 3 datas importantes
        data_input = input(f"{RED}Outra data importante (formato ddmmaa ou ddmmaaaa) ou deixe em branco para continuar: {WHITE}").strip()
        print(f"{RESET}", end='')
        if data_input:
            data_formatada = formatar_data(data_input)
            entradas_basicas.extend([data_input, data_formatada])
        else:
            break

    # Palavras-chave
    for _ in range(3):  # Limitar a 3 palavras-chave
        palavra_input = input(f"{RED}Palavra-chave especial (algo significativo para a pessoa) ou deixe em branco para continuar: {WHITE}").strip()
        print(f"{RESET}", end='')
        if palavra_input:
            palavras = processar_input(palavra_input)
            entradas_basicas.extend(palavras)
        else:
            break

    # Remover entradas vazias e duplicadas
    entradas_basicas = list(set([entrada for entrada in entradas_basicas if entrada.strip()]))

    return entradas_basicas

def wordlist_generator(entradas_basicas):
    palavras = entradas_basicas

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
    nome_arquivo = f"wordlist_{entradas_basicas[0]}_{entradas_basicas[1]}.txt"
    with open(nome_arquivo, 'w') as file:
        for word in wordlist:
            file.write(word + '\n')

    print(f"Wordlist gerada com {len(wordlist)} palavras e salva em '{nome_arquivo}'")

if __name__ == "__main__":
    print("Criador de Wordlist - Contexto Brasileiro")
    entradas_basicas = obter_entradas_basicas()
    wordlist_generator(entradas_basicas)
