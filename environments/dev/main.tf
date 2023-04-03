


locals {
  environment_name = "dev"
}


module "web_app" {
  source = "../../modules/hello-world"

  # Input Variables
  key_name         = var.key_name
  environment_name = local.environment_name
}