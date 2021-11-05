resource "aws_s3_bucket" "docker-jupyterlab" {
  bucket = "s3-website-test.hashicorp.com"
  acl    = "public-read"
}