
# EC2 variables

variable "key_name" {
  type    = string
  default = "my_key_pairs"
} 

variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  default     = "dev"
}