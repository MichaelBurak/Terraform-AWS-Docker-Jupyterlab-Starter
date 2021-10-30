resource "aws_key_pair" "docker-jupyterlab" {
  # Having issues srenaming rwitching out this key, also should really be in vars or its own file
  key_name = "docker-jupyterlab"
  # You will need to ssh-keygen a keypair by name of 'key' in the same directory as the .tf files 
  public_key = file("key.pub")
  tags = var.resource_tags
}



resource "aws_instance" "docker-jupyterlab" {
  # Using the base free tier Amazon Linux 2 AMI currently
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.docker-jupyterlab.key_name
  # runs the startup script to install and start docker, then run JupyterLab on 8888 w/token auth
  user_data = file("startup.sh")

  vpc_security_group_ids = [
    aws_security_group.vpc-ssh.id,
    aws_security_group.vpc-web.id
  ]

  tags = var.resource_tags
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}