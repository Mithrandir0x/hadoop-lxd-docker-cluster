#!/bin/sh

# Install Docker CE
apt update -qq
apt install -y apt-transport-https ca-certificates curl software-properties-common build-essential
sh -c "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"
apt update -qq
apt install -y docker-ce

# Install Docker-Compose
curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# https://github.com/lxc/lxd/issues/2977#issuecomment-331322777
touch /.dockerenv

# Install network tools
apt install telnet
