variable "region" {
  description = "Region AWS para desplegar recursos"
  default     = "us-east-1"
}

variable "ec2_instancia" {
  default = "t2.micro"
}