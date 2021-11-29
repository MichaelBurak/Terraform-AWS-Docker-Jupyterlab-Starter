# Variable declarations
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "AWS Availability Zone for resources"
  type        = string
  default     = "us-west-2a"
}

# trying to figure out a better way to create a default, can't reference data
# variable "bucket" {
#   description="AWS S3 bucket URL"
#   type = "string"
#   default = "docker-jupyterlab-${data.aws_canonical_user_id.current.id}"
# }



variable "resource_tags" {
  description = "Universal tags across resources"
  type        = map(string)
  default = {
    Name        = "terraform-docker-jupyterlab"
    environment = "dev"
  }
}