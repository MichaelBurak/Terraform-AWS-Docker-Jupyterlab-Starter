#! /bin/bash
sudo yum update
sudo yum -y install docker 
sudo systemctl start docker

# using Token in this way is not recommended in production!
# runs base-notebook image with jupyter lab on port 8888 and token 'easy', mounts volume to VM at present working directory containing the files in .../work 
sudo docker run --name my-jupyter-lab -d -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e JUPYTER_TOKEN="${token}" jupyter/datascience-notebook
# having trouble with this variable --> -v $PWD:/home/jovyan/work jupyter/datascience-notebook