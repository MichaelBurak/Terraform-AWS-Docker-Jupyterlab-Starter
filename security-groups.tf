resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "Allow SSH traffic"

  # allows SSH on port 22, in production would lock down to an IP (range)

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "SSH"
  }
}

resource "aws_security_group" "vpc-web" {
  name        = "vpc-web"
  description = "Allow Ephemeral Port and JupyterLab traffic"

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
    Name = "Web"
  }
}