output "ec2_public_dns" {
  value = aws_instance.docker_jupyterlab.public_dns
}