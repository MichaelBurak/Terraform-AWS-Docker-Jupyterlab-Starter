resource "aws_key_pair" "docker_jupyterlab" {
  key_name = "docker_jupyterlab"
  # You will need to ssh-keygen a keypair by name of 'key' in the same directory as the .tf files 
  public_key = file("key.pub")
}

resource "aws_security_group" "docker_jupyterlab" {
  name        = "docker_jupyterlab_security-group"
  description = "Allow SSH, Ephemeral Port and JupyterLab traffic"

  # allows SSH on port 22, in production would lock down to an IP (range)

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # should be in NACL later and shut down insecure ports -- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html#nacl-ephemeral-ports  
  ingress {
    description = "Ephemeral Ports"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for JupyterLab, this can remain but preferably change to your own IP (range) 
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

resource "aws_instance" "docker_jupyterlab" {
  # Using the base free tier Amazon Linux 2 AMI currently
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.docker_jupyterlab.key_name
  # runs the startup script to install and start docker, then run JupyterLab on 8888 w/token auth
  user_data = file("startup.sh")

  vpc_security_group_ids = [
    aws_security_group.docker_jupyterlab.id
  ]

  tags = {
    Name = "Terraform"
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}