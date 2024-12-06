#!/usr/bin/env python3


import time
import os

def countdown_visual(milliseconds):
    # Limpa a tela antes de começar
    os.system('cls' if os.name == 'nt' else 'clear')

    print("\033[91m" + """
888b     d888  .d88888b.  8888888b.  8888888        d8888 8888888b. 88888888888 Y88b   d88P
8888b   d8888 d88P" "Y88b 888   Y88b   888         d88888 888   Y88b    888      Y88b d88P
88888b.d88888 888     888 888    888   888        d88P888 888    888    888       Y88o88P
888Y88888P888 888     888 888   d88P   888       d88P 888 888   d88P    888        Y888P
888 Y888P 888 888     888 8888888P"    888      d88P  888 8888888P"     888         888
888  Y8P  888 888     888 888 T88b     888     d88P   888 888 T88b      888         888
888   "   888 Y88b. .d88P 888  T88b    888    d8888888888 888  T88b     888         888
888       888  "Y88888P"  888   T88b 8888888 d88P     888 888   T88b    888         888

""")
    print("ATENÇÃO: Sistema comprometido! Tempo restante para a destruição total dos dados:\n")
    print("\033[95mMensagem de boas-vindas:\033[0m")
    print("\033[93m'Ah, meus queridos. Vocês acham que podem me pegar? Tão previsíveis...\n"
          "Enquanto vocês se digladiam, tentando resolver os cacos da sua incompetência,\n"
          "eu continuo aqui, no meio de vocês. Observando, calculando, vencendo.\n"
          "Vocês podem correr, mas já é tarde demais. No final, a LAD sempre vence.'\033[0m\n")

    while milliseconds:
        hours, remainder = divmod(milliseconds // 1000, 3600)
        minutes, seconds = divmod(remainder, 60)
        millis = milliseconds % 1000
        timer = f"{hours:02d}:{minutes:02d}:{seconds:02d}:{millis:03d}"
        print(f"\033[93mTempo restante: {timer}\033[0m", end="\r")
        time.sleep(0.001)
        milliseconds -= 1

    print("\033[91m\nARQUIVOS PERDIDOS! Todos os dados foram destruídos!\033[0m")
    print("\033[91mA LAD venceu.\033[0m")

if __name__ == "__main__":
    countdown_visual(7200000)  # 7200000 milissegundos = 2 horas
