resource "random_pet" "s3prefix" {
  length = 3
}

resource "aws_s3_bucket" "docker-jupyterlab" {
  #   bucket = "s3-website-test.hashicorp.com" --> now just assigns and outputs random
  bucket = "${random_pet.s3prefix.id}-jupyter-bucket"
  # leaving it on public read for access from instance until IAM is set up
  acl = "public-read"
}