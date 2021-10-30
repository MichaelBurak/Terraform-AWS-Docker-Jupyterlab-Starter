# Variable declarations
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "resource_tags" {
  description = "Universal tags across resources"
  type        = map(string)
  default = {
    name        = "terraform-docker-jupyterlab"
    environment = "dev"
  }
}