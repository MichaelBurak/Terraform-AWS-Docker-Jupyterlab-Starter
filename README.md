# Terraform AWS Docker JupyterLab Starter

This is a set of Terraform files and shell scripting to spin up a basic EC2 instance with a Dockerized version of a basic Jupyter Notebook environment with JupyterLab for DS/ML development.

## The Infrastructure In Question
The following is provisioned by this Terraform script:
- An EC2 instance (defaulting to a t2.micro AWS Linux 2 VM in us-west-2a) with:
    - Elastic Block Storage(8GB) volume attached
    - CloudWatch Metric Alarm for monitoring CPU utilization
    - Security groups allowing for SSH inbound, ephemeral ports inbound, and port 8888 inbound(for accessing JupyterLab)
    - AWS Key Pair for SSH access
    - S3 bucket for external storage
    - Dockerized JupyterLab using the [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html) installed and running on port 8888, attached via. Docker volumes to persist data. 

## How It Works (High-Level)
- Terraform is used to provision the appropriate AWS resources and install using user_data of a shell script the necessary Docker resources, then pull down and run JupyterLab off an existing image from Jupyter Docker Stacks. 

## Pre-reqs

- AWS CLI installed configured: to allow for access to AWS credentials from Terraform with a user who has permissions to administrate EC2 instances and other resources involved (will work on getting together a list and sample permissions for an IAM role instead of using AWS CLI's IAM creds.)
- Terraform installed

## How To 
- Create a key pair using ssh keygen by the name of "key" (or change the *aws_key_pair* argument *public_key*'s file name resource accordingly, I may change this to a variable going forward.) I am looking into automating this creation and use. 
- Run ``` terraform init ``` --> ``` terraform fmt ``` --> ``` terraform validate ``` --> ``` terraform plan ``` --> ``` terraform apply ```  to create/modify the resources, and ``` terraform destroy ``` the resources in state. 
- To access JupyterLab, use the output ec2 public dns at ``` :8888/lab?token=easy ```

## TO DO: 
- IAM role for this project only assumed via. STS? (Nt sure if necessary.)
- Move ephemeral port opening to NACL.
- Use salted hash password for entry instead of insecure token, or at least pass the token string in as input to tf, figure out SSL and certificates.
- Implement non ec2-user user for linux VM, i.e. user for Docker/JupyterLab only. (Not sure if necessary, ec2-user isn't root but just default to my understanding.)
- SSH keygen automation for setup?
- Install boto on create for JupyterLab
- Allow S3 access to S3 bucket for working on files with Boto in Jupyter
- Use S3 for state storage.
- Decide if using elastic IP by default, set up DNS, etc. bells and whistles (have set up EBS)
- Figure out any remaining reasonable inputs and outputs to include. 
- Autoscaling groups OR move to Kubernetes(EKS) and a more robust VM to run ML workloads on.

## Things I've Learned About/Observations:
- cloud-init for user_data logs
- Jupyter notebook auth fiddling around between (failing at) setting a password to setting a token in various ways.
- Unsetting environmental variables of AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY for AWS credentials was needed for some reason to use terraform's AWS provider?
- That I am still not sure what or if to tag AWS resources with default tags.
- Ephemeral ports and their relationship to inbound traffic on Linux such as yum commands
- NACL, ACL, security group intricacies.
- Some linux command line stuff that didn't make the cut, such as work with awk and redirecting/parsing log stuff. 
- Terraform provisioners are evidently not that popular and have issues, or I'd have used remote exec.
- Some of the definite limitations of Terraform as specifically a provisioning tool are shored up here by user_data and shell scripting, but I can see the usefulness of Ansible and/or Jenkins here and might integrate them. 
- Packer might be worth examining for a purpose-built lean ML IDE AMI/VM.
- Better practices with Terraform projects(i.e. not lazily putting everything in main.tf)
- Network interfaces and security groups and other interactions/connections between resources around EC2.
- Better use of variables.
- Lifecycle rules re: not refreshing instances when AMI updates.
- Attachment points on unix devices and how to best attach EBS volumes to EC2 instances.

## Resources Used:
- https://dev.to/aakatev/deploy-ec2-instance-in-minutes-with-terraform-ip2
- https://liamarjitbhogal.wordpress.com/2018/10/13/what-port-does-yum-use-in-amazon-aws/
- https://github.com/JainSkariahThomas/Terraform
- https://www.kisphp.com/terraform/terraform-find-ubuntu-and-amazon-linux-2-amis
- https://www.cloudbees.com/blog/terraforming-your-docker-environment-on-aws
- https://www.thinkstack.co/blog/using-terraform-to-create-an-ec2-instance-with-cloudwatch-alarm-metrics
- https://www.udemy.com/course/terraform-on-aws-with-sre-iac-devops-real-world-demos/learn/
- https://kodekloud.com/ 's Terraform For Absolute Beginners course
