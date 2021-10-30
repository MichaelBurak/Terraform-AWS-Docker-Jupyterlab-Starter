terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  # change region if you need to for cost purposes, etc, but make sure to use a supported AMI
  region = "us-west-2"
}

resource "aws_key_pair" "ubuntu_jupyterlab" {
  key_name = "ubuntu_jupyterlab"
  # You will need to ssh-keygen a keypair by name of 'key' in the same directory as the .tf files 
  # (think of ways of automating this process?)
  public_key = file("key.pub")
}

resource "aws_security_group" "ubuntu_jupyterlab" {
  name        = "ubuntu_jupyterlab_security-group"
  description = "Allow SSH, HTTPS, HTTP and Jupyter Lab traffic"

  # ingress should be more limited in any non-testing capacity

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for jupyter lab, this can remain but preferably change to your own IP 
  ingress {
    description = "HTTP"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allows outbound traffic permissively
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform"
  }
}

resource "aws_instance" "ubuntu_jupyterlab" {
  # Using the base free tier Amazon Linux 2 AMI
  ami           = "ami-013a129d325529d4d"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ubuntu_jupyterlab.key_name
  # runs the startup script to install and start docker, run jupyter lab on 8888 w/token auth
  user_data = file("startup.sh")

  vpc_security_group_ids = [
    aws_security_group.ubuntu_jupyterlab.id
  ]

  tags = {
    Name = "Terraform"
  }
}


# would add an elastic IP, may be useful
# resource "aws_eip" "ubuntu_jupyterlab" {
#   vpc      = true
#   instance = aws_instance.ubuntu_jupyterlab.id
# }
