#creación de network (VPC, subnet, Gateway, Tabla de rutas)

resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "example-vpc" }
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"

  tags = { Name = "example-subnet" }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = { Name = "example-igw" }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = { Name = "example-route-table" }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

#creación  de grupos de seguridad

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "web-sg" }
}

#creación de política de roles

resource "aws_iam_role" "example_role" {
  name = "example-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "example_policy" {
  name = "example-policy"
  role = aws_iam_role.example_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:List*",
        "s3:Get*",
        "s3:ReplicateTags",
        "s3:CreateBucket",
        "s3:DeleteBucket"
      ]
      Resource = "*"
    }]
  })
}
#creación de buckets S3"

resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true
    expiration {
      days = 15
    }
  }

  tags = { Name = var.bucket_name }
}

#Creación de instancia EC2

resource "aws_instance" "web" {
  ami           = "ami-0b898040803850657" # Amazon Linux 2 kernel 6.1
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = { Name = "ExampleInstance" }
}
