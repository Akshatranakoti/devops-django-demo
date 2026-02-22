provider "aws" {
  region = "ap-south-1"
}

# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets from default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1a"]
  }
}

# Get latest Ubuntu automatically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "devops_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # 🔴 Replace with your existing AWS keypair name
  key_name = "test"

  subnet_id = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  tags = {
    Name = "devops-django-server"
  }
}

output "public_ip" {
  value = aws_instance.devops_server.public_ip
}