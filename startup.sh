#! /bin/bash
sudo yum update
sudo yum -y install docker 
sudo systemctl start docker
sudo docker run -d -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes jupyter/base-notebook