provider "aws" {
region = var.aws_region
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-access"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "lab" {
bucket = var.bucket_name
}
resource "aws_s3_bucket_versioning" "versioning" {
bucket = aws_s3_bucket.lab.id
versioning_configuration {
status = "Enabled"
}
}
resource "aws_instance" "app_server" {
ami = "ami-0341d95f75f311023" # Amazon Linux 2
instance_type = "t2.micro"
key_name = "control-node"
tags = {
Name = "Sprint5-EC2"
}
}
output "bucket_name" {
value = aws_s3_bucket.lab.bucket
}
output "ec2_public_ip" {
value = aws_instance.app_server.public_ip
}


