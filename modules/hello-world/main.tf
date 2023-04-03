terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

# EC2 instance 
resource "aws_instance" "EC2-instance" {
  ami                     = "ami-0dcc1e21636832c5d"
  instance_type           = "m2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name

  tags {
    Name = "hello-world"
  }
}

# Create keypairs 

resource "tls_private_key" "p_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.p_key.public_key_openssh
}

# Security group

resource "aws_security_group" "allow_web" {
name        = "webserver"
vpc_id      = module.it_internal_vpc.vpc_id
description = "Allows access to Web Port"
#allow http 
ingress {
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
# allow https
ingress {
from_port   = 443
to_port     = 443
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
# allow SSH
ingress {
from_port   = 22
to_port     = 22
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
#all outbound
egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
stack = "test"
}
lifecycle {
create_before_destroy = true
}
} #security group ends here


# Create IAM role, attache it to ec2 with ssm core policy to the role

resource "aws_iam_instance_profile" "dev-resources-iam-profile" {
name = "ec2_profile"
role = aws_iam_role.dev-resources-iam-role.name
}

resource "aws_iam_role" "dev-resources-iam-role" {
name        = "dev-ssm-role"
description = "The role for the developer resources EC2"
assume_role_policy = jsonencode({
    "Version": "2012-10-17"
    "Statement": {
        "Effect": "Allow"
        "Principal": {
            "Service": "ec2.amazonaws.com"
        }
        "Action": "sts:AssumeRole"
    }
})

tags = {
  Name = "aws_iam_role"
}
}

resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
role       = aws_iam_role.dev-resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


