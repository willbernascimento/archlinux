import subprocess
import re
from pathlib import Path

PRIME_STATUS_FILE = "prime-custom-setup"
XINITRC_FILE = "xinitrc"
HOME_PATH = str(Path.home())

PRIME_RENDER_FILE = '10-prime-render-offload.conf'
XORG_CONF_DIR = Path('/etc/xorg.conf.d/')

GDM_CUSTOM_FILE = "custom.conf"
GDM_DIR = Path("/etc/gdm/")


# indentificando configuracao atual

st_status_file = subprocess.call(f'test -e {HOME_PATH}/.{PRIME_STATUS_FILE}', shell=True)

if st_status_file == 0:
    print("Lendo status de configuração")

    file1 = open(f'{HOME_PATH}/.{PRIME_STATUS_FILE}', 'r+')
    file1_line = " ".join(file1.readlines()).strip()
    print(f'--{file1_line}--')
    file1.close()

    if file1_line == "hybrid-mode":
        print(f'Você está usando o modelo {file1_line} \n Iremos configurar para o modo: intel-only')
        print('Removendo o arquivo Nvidia-prime do xorg')
        rm_prime_rende_file = subprocess.run(f'sudo rm {XORG_CONF_DIR}/{PRIME_RENDER_FILE}', check=True, capture_output=True, text=True,shell=True)
        
        print('Restaurando a configuracao GDM padrão')
        mv_gdm_custom_file = subprocess.run(f'sudo mv {GDM_DIR}/{GDM_CUSTOM_FILE}.prime-bkp {GDM_DIR}/{GDM_CUSTOM_FILE}', check=True, capture_output=True, text=True,shell=True)
        
        st_xinitrc_file = subprocess.call(f"test -e {HOME_PATH}/.{XINITRC_FILE}", shell=True)

        if st_xinitrc_file == 0:
            print('Restaurando arquivo xinitrc padrão')
            mv_xinitrc_file = subprocess.run(f'mv {HOME_PATH}/.{XINITRC_FILE}.prime-bkp {HOME_PATH}/.{XINITRC_FILE}', check=True, capture_output=True, text=True, shell=True)


        KERNEL_INSTALADO = 'linux'
        PACOTES_REMOVIDOS = " ".join(['nvidia', 'nvidia-prime', 'nvidia-settings', 'nvidia-utils'])

        print('Removendo pacotes Nvidia')
        rm_pacotes_nvidia =  subprocess.run(f'sudo pacman -R {PACOTES_REMOVIDOS}', check=True, capture_output=True, text=True, shell=True)

        print('Refazendo imagem mkinitcpio')
        out_mkinitcpio = subprocess.run(f'sudo mkinitcpio -p {KERNEL_INSTALADO}', check=True, capture_output=True, text=True, shell=True)

        subprocess.run(f'echo "intel-only" > {HOME_PATH}/.{PRIME_STATUS_FILE}', check=True, capture_output=True, text=True, shell=True)
        print('Salvando status no arquivo ~/.prime-custom-setup')
        print('Processo finalizado, reinicie o computador para usar apenas intel ...')
    else:
        print("Nao identifiquei sua configuração prime atual. Abortando...")                       
else:
    print("Parece que não há arquivos de sua configuração prime ainda. \n Se você quer configurar sua placa nvidia: use hybrid-mode. \n Abortando operação...")
    exit()
