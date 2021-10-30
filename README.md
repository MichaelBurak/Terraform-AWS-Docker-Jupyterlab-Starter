# Terraform AWS Docker Jupyterlab Starter

This is a set of Terraform files and shell scripting to spin up a basic EC2 instance with a Dockerized version of a basic Jupyter Notebook environment with Jupyterlab for DS/ML development.

## Pre-reqs

- AWS CLI installed configured: to allow for access to AWS credentials from Terraform with a user who has permissions to CRUD EC2 instances and other resources involved (will work on getting together a list and sample permissions.)
- Terraform installed

## How To 
- Create a key pair using ssh keygen by the name of "key" (or change the *aws_key_pair* argument *public_key*'s file name resource accordingly, I may change this to a variable going forward.) I am looking into automating this creation and use. 
- Run ``` terraform init ``` --> ``` terraform fmt ``` --> ``` terraform validate ``` --> ``` terraform plan ``` --> ``` terraform apply ```  to create/modify the resources, and ``` terraform destroy ``` the resources in state. 
- To get where to ssh into for accessing Jupyter Lab(this is where I am currently working hardest to streamline and automate) you will need to ssh using the specified key into the instance, then run ``` docker ps ``` --> ``` docker logs [CONTAINER ID] ``` of the running Jupyter Notebook + Lab to get the URL with the token, then use the output EC2 DNS at port 8888 to login via. token. 

## TO DO: 
- Getting the login token or setting password for Jupyter Lab to allow for logging in without looking at jupyter/docker logs for the token.
- Change ingress rules to be less permissive.
- SSH keygen automation.
- Figuring out saving state method.
- Decide if using elastic IP by default. 
- Refactor the tags for the instance and attendant resources.
- Figure out reasonable inputs and outputs to include. 
- --name on the Docker run command in the shell script.

## Resources Used:
- https://dev.to/aakatev/deploy-ec2-instance-in-minutes-with-terraform-ip2
