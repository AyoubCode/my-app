#!/bin/bash
set -euo pipefail

# Change directory to example
cd ../../dev

# Create the resources
terraform init
terraform apply --auto-approve

# Wait while the instance boots up
# (Could also use a provisioner in the TF config to do this)
sleep 60 

# Test the web server 
EC2_PUBLIC_IP=$(terraform output -raw ec2_public_ip)
curl http://${EC2_PUBLIC_IP}:8080 -m 10

# If request succeeds, destroy the resources
terraform destroy -auto-approve


