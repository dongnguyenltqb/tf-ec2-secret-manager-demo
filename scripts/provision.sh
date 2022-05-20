#!/bin/bash
sudo su ubuntu
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y zip unzip jq ca-certificates curl gnupg lsb-release docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo chown ubuntu:ubuntu /home/ubuntu/.docker -R
sudo chmod g+rwx "/home/ubuntu/.docker" -R
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install