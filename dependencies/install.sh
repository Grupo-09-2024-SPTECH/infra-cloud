#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-venv -y

sudo python3 -m venv pyenv
source pyenv/bin/activate

sudo pip3 install --upgrade --force-reinstall jupyterlab
sudo pip3 install notebook
sudo pip3 install qtconsole
sudo pip3 install pandas
sudo pip3 install scikit-learn
sudo pip3 install mysql-connector-python
sudo pip3 install boto3
sudo pip3 install numpy

sudo echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc
source ~/.bashrc
source pyenv/bin/activate

# Gera o arquivo de configuração do Jupyter
jupyter notebook --generate-config

# Adiciona configurações para desabilitar autenticação por senha
echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py

git clone https://github.com/Grupo-09-2024-SPTECH/artificial-intelligence.git

# Inicia o Jupyter Lab sem autenticação
jupyter-lab --ip 0.0.0.0 --allow-root