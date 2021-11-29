resource "random_pet" "token" {
  length = 2
}


resource "aws_key_pair" "docker-jupyterlab" {
  # Having issues renaming or switching out this key, also should really be in vars or its own file
  key_name = "docker-jupyterlab"
  # You will need to ssh-keygen a keypair by name of 'key' in the same directory as the .tf files 
  public_key = file("key.pub")
  tags       = var.resource_tags
}



resource "aws_instance" "docker-jupyterlab" {
  # Using the base free tier Amazon Linux 2 AMI currently
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.docker-jupyterlab.key_name
  # runs the startup script to install and start docker, then run JupyterLab on 8888 w/token auth
  user_data         = templatefile("startup.sh", { token = random_pet.token.id })
  availability_zone = var.availability_zone

  vpc_security_group_ids = [
    aws_security_group.vpc-ssh.id,
    aws_security_group.vpc-web.id
  ]

  tags = var.resource_tags

  # enforces behavir that TF does not recreate instance when ami is updated
  lifecycle {
    ignore_changes = [ami]
  }

}

resource "aws_ebs_volume" "docker-jupyterlab" {
  # change from hardcoded size later
  availability_zone = var.availability_zone
  size              = 8
}

resource "aws_volume_attachment" "docker-jupyterlab" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.docker-jupyterlab.id
  instance_id = aws_instance.docker-jupyterlab.id
}

resource "aws_cloudwatch_metric_alarm" "docker-jupyterlab" {
  alarm_name                = "cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization, altering when average CPU utilization exceeds 80% in 2 evaluation periods that last 120 seconds each."
  insufficient_data_actions = []

  dimensions = {

    InstanceId = aws_instance.docker-jupyterlab.id

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