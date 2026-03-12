#!/bin/bash
cd
sudo yum update -y
sudo yum install docker containerd git screen -y

# Cleaner Docker Compose Installation
sudo mkdir -p /usr/libexec/docker/cli-plugins
sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/libexec/docker/cli-plugins/docker-compose
sudo chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Start and configure Docker
systemctl enable docker.service --now
sudo usermod -a -G docker ssm-user
sudo usermod -a -G docker ec2-user
systemctl restart docker.service

# Pull and run a different app (WordPress) that uses your DB variables
docker pull wordpress:latest
docker run -d \
  -e WORDPRESS_DB_HOST=${mysql_url} \
  -e WORDPRESS_DB_USER=admin \
  -e WORDPRESS_DB_PASSWORD=Admin12345 \
  -e WORDPRESS_DB_NAME=terraformdb \
  -p 80:80 wordpress:latest