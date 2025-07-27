#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y docker.io awscli
sudo systemctl enable docker
sudo systemctl start docker

echo "${docker_password}" | sudo docker login -u "${docker_username}" --password-stdin
sudo docker pull ${docker_image}
sudo docker run -d -p 3000:3000 --name node-app ${docker_image}
