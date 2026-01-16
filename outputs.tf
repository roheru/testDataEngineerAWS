output "bucket_name" {
  description = "Nombre del bucket S3 creado"
  value       = aws_s3_bucket.example_bucket.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.web.public_ip
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.example.id
}

output "subnet_id" {
  description = "ID de la Subnet"
  value       = aws_subnet.example.id
}