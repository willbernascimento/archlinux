from os import mkdir
from pathlib import Path
import subprocess
import re

# pacotes necessarios (precisa ver como lidar com linux-lts)

PACOTES_NECESSARIOS = ['nvidia', 'nvidia-prime', 'nvidia-settings', 'nvidia-utils', 'linux']

# pacotes instalados

PACOTES_INSTALADOS = subprocess.run("pacman -Qn", check=True, capture_output=True, text=True, shell=True)
PACOTES_INSTALADOS_OUT = PACOTES_INSTALADOS.stdout.split("\n")

pacotes_instalados_sv = []

for i in PACOTES_INSTALADOS_OUT:
    pacotes_instalados_sv.append(re.sub("\s(.*)", "", i))  


nao_instalados = []

for i in PACOTES_NECESSARIOS:
    if i not in pacotes_instalados_sv:
        nao_instalados.append(i)

if len(nao_instalados) > 0:
    print(f'Os pacotes  {" ".join(nao_instalados)} são necessários. Instale-os e tente novamente!')
    exit()


# Configurando o prime

print('Copiando arquivos de configuração \n')

PRIME_RENDER_FILE = '10-prime-render-offload.conf'
XORG_CONF_DIR = Path("/etc/xorg.conf.d/")


if not XORG_CONF_DIR.exists():
    mkdir_xorg_conf_dir = subprocess.run(f'sudo mkdir -p {XORG_CONF_DIR}', check=True, capture_output=True, text=True, shell=True)

out_copia_prime_rende_file = subprocess.run(f'sudo cp -r {PRIME_RENDER_FILE} {XORG_CONF_DIR}/{PRIME_RENDER_FILE}', check=True, capture_output=True, text=True, shell=True)




# configurando o gdm (cria mensagem explicando o que acontecendo)

print('Desabilitando wayland \n')

GDM_CUSTOM_FILE = "custom.conf"
GDM_DIR = "/etc/gdm/"

out_backup_gdm_custom_file = subprocess.run(f'sudo cp -r {GDM_DIR}/{GDM_CUSTOM_FILE} {GDM_DIR}/{GDM_CUSTOM_FILE}.prime-bkp', 
                                            check=True, 
                                            capture_output=True, 
                                            text=True, 
                                            shell=True)


out_copia_gdm_custom_file = subprocess.run(f'sudo cp -r {GDM_CUSTOM_FILE} {GDM_DIR}', 
                                            check=True, 
                                            capture_output=True, 
                                            text=True, 
                                            shell=True)


# xinitrc 

XINITRC_FILE = "$HOME/.xinitrc"

status = subprocess.call("test -e '{}'".format(XINITRC_FILE), shell=True)

if status == 0:
    out_backup_xinitrc_file = subprocess.run(f'mv {XINITRC_FILE} {XINITRC_FILE}.prime-bkp', 
                                            check=True, 
                                            capture_output=True, 
                                            text=True, 
                                            shell=True)
                        


# cria a imagem do kernel (precisa ver como lidar com linux-lts)

print('Criando a imagem com mkinitcpio \n')

KERNEL_INSTALADO = 'linux' #vai la pra cima essa variavel

out_mkinitcpio = subprocess.run(f'sudo mkinitcpio -p {KERNEL_INSTALADO}', 
                                            check=True, 
                                            capture_output=True, 
                                            text=True, 
                                            shell=True)





# salva arquivo para testar o estado atual da configuracao
#staus: hybrid-mode
#       nvidia-only
#       intel-only

STATUS_FILE = "prime-custom-setup"

subprocess.run(f'echo "hybrid-mode" > $HOME/.{STATUS_FILE}', 
                                            check=True, 
                                            capture_output=True, 
                                            text=True, 
                                            shell=True) 



print('Salvando status no arquivo ~/.prime-custom-setup \n')
print('Processo finalizado, reinicie o computador para usar o prime ...')

# a ideia e testar o status do arquivo. Para idenfificar como proceder
# na limpeza deles para alterar o estado

# if subprocess.call("test -e '{}'".format(XINITRC_FILE), shell=True)
