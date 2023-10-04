#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
mkdir newfolder
cd newfolder 
echo '<h1>HelloWorld</h1>' > index.html
echo -e "FROM nginx:latest\nCOPY . /usr/share/nginx/html" > Dockerfile
sudo docker build -t hello .
sudo docker run --name hellowww -p 80:80 -d hello