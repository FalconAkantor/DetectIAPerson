#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt-get update && sudo apt-get upgrade -y

# Instalar Python 3 y pip
echo "Instalando Python 3 y pip..."
sudo apt-get install -y python3 python3-pip

# Instalar ffmpeg
echo "Instalando ffmpeg..."
sudo apt-get install -y ffmpeg

# Instalar curl
echo "Instalando curl..."
sudo apt-get install -y curl

echo "Instalacion completa."

# Crear un archivo README para configuraciones adicionales
cat
