
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
  region = var.region
}

locals {
  environment_name = "dev"
}


module "web_app" {
  source = "../../modules/hello-world"

  # Input Variables
  key_name         = var.key_name
  environment_name = local.environment_name
  region           = var.region
}