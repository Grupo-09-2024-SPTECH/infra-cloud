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