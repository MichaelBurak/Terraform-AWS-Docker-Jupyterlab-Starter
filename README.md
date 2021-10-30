# Terraform AWS Docker JupyterLab Starter

This is a set of Terraform files and shell scripting to spin up a basic EC2 instance with a Dockerized version of a basic Jupyter Notebook environment with JupyterLab for DS/ML development.

## Pre-reqs

- AWS CLI installed configured: to allow for access to AWS credentials from Terraform with a user who has permissions to CRUD EC2 instances and other resources involved (will work on getting together a list and sample permissions for an IAM role instead of using AWS CLI's IAM creds.)
- Terraform installed

## How To 
- Create a key pair using ssh keygen by the name of "key" (or change the *aws_key_pair* argument *public_key*'s file name resource accordingly, I may change this to a variable going forward.) I am looking into automating this creation and use. 
- Run ``` terraform init ``` --> ``` terraform fmt ``` --> ``` terraform validate ``` --> ``` terraform plan ``` --> ``` terraform apply ```  to create/modify the resources, and ``` terraform destroy ``` the resources in state. 
- To access JupyterLab, use the output ec2 public dns at ``` :8888/?token=easy ```

## TO DO: 
- IAM role for this project only assumed via. STS.
- Change ingress rules to be SSH and move ephemeral port opening to NACL.
- Use salted hash password for entry instead of insecure token, or at least pass the token string in as input to tf.
- Implement non ec2-user user for linux VM, i.e. user for Docker/JupyterLab only. (Is this needed? ec2-user isn't root but just default to my understanding.)
- SSH keygen automation?
- Figuring out saving state method.
- Change AWS AMI id to grab latest free tier / t2.micro instead of hardcoding?
- Decide if using elastic IP by default, set up DNS, etc. bells and whistles
- Refactor the tags for the instance and attendant resources.
- Figure out any reasonable inputs and outputs to include. 
- Move to Kubernetes(EKS) and a more robust VM to run ML workloads on.

## Things I've Learned About:
- cloud-init for user_data logs
- Jupyter notebook auth fiddling around between (failing at) setting a password to setting a token in various ways.
- Unsetting environmental variables for AWS credentials was needed for some reason to use terraform's AWS provider??
- That I am still not sure what or if to tag AWS resources with default tags.
- Ephemeral ports and their relationship to inbound traffic on Linux such as yum commands

## Resources Used:
- https://dev.to/aakatev/deploy-ec2-instance-in-minutes-with-terraform-ip2
- https://liamarjitbhogal.wordpress.com/2018/10/13/what-port-does-yum-use-in-amazon-aws/
- https://github.com/JainSkariahThomas/Terraform
