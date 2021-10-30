output "ec2-public-dns" {
  value = aws_instance.docker-jupyterlab.public_dns
}