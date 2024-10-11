# # Key Pair for the instance
# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = file("~/.ssh/id_ed25519.pub")
# }
# AWS Key Pair for Deployer
# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer"
#   public_key = var.public_key_content  # You need to have a variable for the public key content
# }
# variable "public_key_content" {
#   description = "The public key to be used for the AWS key pair."
#   type        = string
# }
