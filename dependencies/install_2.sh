#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

# Nome do novo usuário
NOVO_USUARIO="urubu100"

# Adicionar o novo usuário sem senha
sudo adduser $NOVO_USUARIO --gecos "" --disabled-password

# Adicionar o novo usuário ao grupo sudo
sudo usermod -aG sudo $NOVO_USUARIO

# Configurar o novo usuário para não precisar de senha para sudo
echo "$NOVO_USUARIO ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$NOVO_USUARIO

# Trocar para o novo usuário sem solicitar senha
sudo su - $NOVO_USUARIO

sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-venv -y

mkdir myproject
cd myproject
python3 -m venv pyenv

source pyenv/bin/activate

pip install jupyter

# Gera o arquivo de configuração do Jupyter
jupyter notebook --generate-config

# Adiciona configurações para desabilitar autenticação por senha
echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py

git clone https://github.com/Grupo-09-2024-SPTECH/artificial-intelligence.git

touch ./artificial-intelligence/script/util/credentials.py

# Inicia o Jupyter Lab sem autenticação
jupyter-lab --ip 0.0.0.0 --allow-root