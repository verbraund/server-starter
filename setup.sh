#!/bin/bash

set -e

sudo apt-get update -y
sudo apt-get upgrade -y

## INSTALL DOCKER
if ! command -v docker >/dev/null 2>&1; then

    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker ${USER}

fi

sudo docker --version

## Create link
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ln -sfn releases/1 $PROJECT_ROOT/www/current

mkdir -p $PROJECT_ROOT/nginx/ssl

openssl req -x509 -newkey rsa:2048 \
    -sha256 \
    -days 365 \
    -noenc \
    -keyout $PROJECT_ROOT/nginx/ssl/site.key \
    -out $PROJECT_ROOT/nginx/ssl/site.crt \
    -subj "/CN=site.local" \
    -addext "subjectAltName=DNS:site.local" \
    -addext "basicConstraints=critical,CA:FALSE" \
    -addext "extendedKeyUsage=serverAuth"

## Create containers
sudo docker compose up -d