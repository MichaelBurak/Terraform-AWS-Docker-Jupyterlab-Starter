# Terraform AWS Docker Jupyterlab Starter

This is a set of Terraform files and shell scripting to spin up a basic EC2 instance with a Dockerized version of a basic Jupyter Notebook environment with Jupyterlab for DS/ML development.

## How To 
- Create a key pair using ssh keygen by the name of "key" (or change the *aws_key_pair* argument *public_key*'s file name resource accordingly, I may change this to a variable going forward.) I am looking into automating this creation and use. 
- Run ``` terraform fmt ``` --> ``` terraform validate ``` --> ``` terraform plan ``` --> ``` terraform apply ```  to create/modify the resources, and ``` terraform destroy ``` the resources in state. 
- To get where to ssh into for accessing Jupyter Lab(this is where I am currently working hardest to streamline and automate) you will need to ssh using the specified key into the instance, then run ``` docker ps ``` --> ``` docker logs [CONTAINER] ``` of the running Jupyter Notebook + Lab to get the URL with the token, then use the output EC2 DNS at port 8888 to login via. token. 

## TO DO: 
- Include volume(s) for persistence.
- Implement non ec2-user user for linux VM, user for docker/jupyterlab only.
- Change ingress rules to be less permissive.
- Use salted hash password for entry instead of insecure token, or at least pass the token string in as input to tf.
- SSH keygen automation.
- Figuring out saving state method.
- Decide if using elastic IP by default. 
- Refactor the tags for the instance and attendant resources.
- Figure out any reasonable inputs and outputs to include. 
- Move to Kubernetes and a more robust VM to run ML workloads on.

## Resources Used:
- https://dev.to/aakatev/deploy-ec2-instance-in-minutes-with-terraform-ip2
