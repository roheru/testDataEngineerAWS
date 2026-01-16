variable "region" {
  description = "Region AWS para desplegar recursos"
  default     = "us-east-2"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "bucket_name" {
  description = "example_bucket_variable"
  default     = "my-example-bucket-terraform"
}