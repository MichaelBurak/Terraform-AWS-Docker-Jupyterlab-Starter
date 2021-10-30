output "ec2_public_dns" {
  value = aws_instance.ubuntu_jupyterlab.public_dns
}