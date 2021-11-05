# Output variables

output "ec2-public-dns" {
  value = aws_instance.docker-jupyterlab.public_dns
}

output "s3-bucket-domain" {
  value = aws_s3_bucket.docker-jupyterlab.bucket_domain_name
}