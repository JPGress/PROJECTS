#!/usr/bin/env python3
import itertools
import datetime
import unicodedata

# Definição das cores ANSI
RED = '\033[0;91m'
WHITE = '\033[37m'
RESET = '\033[0m'

def remover_acentuacao(texto):
    # Substituir 'ç' por um marcador temporário
    texto = texto.replace('ç', '__CEDILLA__')
    # Normalizar o texto
    texto = unicodedata.normalize('NFD', texto)
    # Substituir 'c' + cedilha combinante pelo marcador temporário
    texto = texto.replace('c\u0327', '__CEDILLA__')
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
    
    # Informações pessoais
    nome_input = input(f"{RED}Nome da pessoa-alvo (se múltiplos nomes, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes = processar_input(nome_input)
    entradas_basicas.extend(nomes)

    sobrenome_input = input(f"{RED}Sobrenome da pessoa-alvo (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    sobrenomes = processar_input(sobrenome_input)
    entradas_basicas.extend(sobrenomes)

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

    ano_nascimento = input(f"{RED}Ano de nascimento (ex: 1990): {WHITE}").strip()
    print(f"{RESET}", end='')
    mes_nascimento_input = input(f"{RED}Mês de nascimento (1-12): {WHITE}").strip()
    print(f"{RESET}", end='')
    mes_nascimento = formatar_mes(mes_nascimento_input)
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

    # Nomes de usuário em redes sociais
    usernames_input = input(f"{RED}Nomes de usuário em redes sociais (ex: joaosilva123; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    usernames = processar_input(usernames_input)
    entradas_basicas.extend(usernames)

    # Hobbies e interesses
    hobbies_input = input(f"{RED}Hobbies e interesses (ex: futebol, leitura; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    hobbies = processar_input(hobbies_input)
    entradas_basicas.extend(hobbies)

    # Frases ou citações preferidas
    citacoes_input = input(f"{RED}Frases ou citações preferidas (ex: A fé move montanhas; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    citacoes = processar_input(citacoes_input)
    entradas_basicas.extend(citacoes)

    # Nomes de lugares importantes
    lugares_input = input(f"{RED}Nomes de lugares importantes (ex: São Paulo, Cristo Redentor; separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    lugares = processar_input(lugares_input)
    entradas_basicas.extend(lugares)

    # Informações familiares
    nome_pai_input = input(f"{RED}Nome do pai (se múltiplos nomes, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes_pai = processar_input(nome_pai_input)
    entradas_basicas.extend(nomes_pai)

    nome_mae_input = input(f"{RED}Nome da mãe (se múltiplos nomes, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    nomes_mae = processar_input(nome_mae_input)
    entradas_basicas.extend(nomes_mae)

    nome_companheiro_input = input(f"{RED}Nome do companheiro(a) (se houver, separe múltiplos por vírgula): {WHITE}")
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

    artista_favorito_input = input(f"{RED}Artista ou banda favorita (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    artistas_favoritos = processar_input(artista_favorito_input)
    entradas_basicas.extend(artistas_favoritos)

    religiosa = input(f"{RED}A pessoa parece ser religiosa? (sim/nao): {WHITE}").strip()
    print(f"{RESET}", end='')
    if religiosa.lower() == "sim":
        contexto_religioso = ["Deus", "Jesus", "Maria", "fe", "oracao", "igreja"]
        entradas_basicas.extend(contexto_religioso)

    # Informações de localização
    cidade_nascimento_input = input(f"{RED}Cidade de nascimento (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    cidades_nascimento = processar_input(cidade_nascimento_input)
    entradas_basicas.extend(cidades_nascimento)

    estado_nascimento_input = input(f"{RED}Estado de nascimento (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    estados_nascimento = processar_input(estado_nascimento_input)
    entradas_basicas.extend(estados_nascimento)

    cidade_moradia_input = input(f"{RED}Cidade atual de moradia (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    cidades_moradia = processar_input(cidade_moradia_input)
    entradas_basicas.extend(cidades_moradia)

    estado_moradia_input = input(f"{RED}Estado atual de moradia (se múltiplos, separe por vírgula): {WHITE}")
    print(f"{RESET}", end='')
    estados_moradia = processar_input(estado_moradia_input)
    entradas_basicas.extend(estados_moradia)

    # Datas importantes
    data_input = input(f"{RED}Data especial (formato ddmmaa ou ddmmaaaa): {WHITE}").strip()
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

    # Variantes de nome
    variantes_nome = []
    for nome in nomes:
        variantes_nome.extend(gerar_variantes_nome(nome))
    entradas_basicas.extend(variantes_nome)

    # Remover entradas vazias e duplicadas
    entradas_basicas = list(set([entrada for entrada in entradas_basicas if entrada.strip()]))

    return entradas_basicas

def formatar_mes(mes):
    meses = {
        "1": "janeiro", "2": "fevereiro", "3": "marco", "4": "abril",
        "5": "maio", "6": "junho", "7": "julho", "8": "agosto",
        "9": "setembro", "10": "outubro", "11": "novembro", "12": "dezembro"
    }
    return meses.get(mes.zfill(2), mes)

def gerar_variantes_nome(nome):
    diminutivos = [nome + "inho", nome + "inha", nome[:3] + "zinho"]
    return diminutivos

def gerar_combinacoes(entradas):
    combinacoes = set()
    for i in range(1, min(4, len(entradas)) + 1):  # Limitando a 4 elementos por permutação
        for combinacao in itertools.permutations(entradas, i):
            combinacao_str = ''.join(combinacao)
            if ' ' in combinacao_str:
                continue  # Pular combinações que contêm espaços
            combinacoes.add(combinacao_str)
            combinacoes.add('_'.join(combinacao))
            combinacoes.add('-'.join(combinacao))
            combinacoes.add('@'.join(combinacao))
    return combinacoes

def adicionar_variacoes(combinacoes):
    anos_relevantes = [str(datetime.datetime.now().year)]
    caracteres_especiais = ["!", "@", "#", "$", "%", "&", "*"]

    for combinacao in combinacoes:
        #if ' ' in combinacao:
            #continue  # Pular combinações que contêm espaços
        yield combinacao
        for ano in anos_relevantes:
            yield combinacao + ano
            yield ano + combinacao
        # Adicionar sequências comuns
        yield combinacao + "123"
        yield "123" + combinacao
        yield combinacao + "2024" 
        yield combinacao + "2023"
        yield combinacao + "2022"
        yield combinacao + "2021"
        yield combinacao + "2020"        
        
        # Adicionar caracteres especiais no início e fim
        for char in caracteres_especiais:
            yield char + combinacao
            yield combinacao + char
            yield char + combinacao + char

        # Aplicar leetspeak apenas se a combinação for menor que 12 characters
        if len(combinacao) <= 12:
            leet = leetspeak(combinacao)
            if leet != combinacao:
                yield leet

def leetspeak(texto):
    substituicoes = {
        'a': '4', 'e': '3', 'i': '1', 'o': '0', 's': '5', 't': '7'
    }
    return ''.join(substituicoes.get(c.lower(), c) for c in texto)

def remover_repetidos(wordlist):
    return set(wordlist)

def salvar_wordlist(wordlist_gen, entradas_basicas, nome_arquivo=None):
    if not nome_arquivo:
        nome_arquivo = entradas_basicas[0] + ".txt"
    try:
        palavras_unicas = set()
        with open(nome_arquivo, 'w', encoding='utf-8') as file:
            for palavra in wordlist_gen:
                if ' ' not in palavra and palavra not in palavras_unicas:
                    file.write(palavra + "\n")
                    palavras_unicas.add(palavra)
        print(f"Wordlist salva como {nome_arquivo}")
    except Exception as e:
        print(f"Erro ao salvar a wordlist: {e}")
        
def main():
    entradas_basicas = obter_entradas_basicas()
    combinacoes = gerar_combinacoes(entradas_basicas)
    wordlist_gen = adicionar_variacoes(combinacoes)
    salvar_wordlist(wordlist_gen, entradas_basicas)

if __name__ == "__main__":
    main()
