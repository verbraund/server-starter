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

## INSTALL GITLAB RUNNER
if [ ! "$(sudo docker ps -aq -f name=gitlab-runner)" ]; then

    sudo docker run -d --name gitlab-runner --restart always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /srv/gitlab-runner/config:/etc/gitlab-runner \
      gitlab/gitlab-runner:latest

    echo "service_healthcheck_timeout = 120" | sudo tee -a /srv/gitlab-runner/config/config.toml
    sudo docker restart gitlab-runner

fi

## Create link
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ln -sfn releases/1 $PROJECT_ROOT/www/current

## Create containers
sudo docker compose up -d