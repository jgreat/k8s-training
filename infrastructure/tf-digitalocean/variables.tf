variable "aws_profile" {}
variable "email" {}
variable "me" {}
variable "ssh_public_key_file" {}

# LetsEncrypt config
variable "server_name" {}

variable "domain" {}

# Use letsencrypt staging cert
variable "staging" {}

# DigitalOcean
variable "do_region" {}

# Agents
variable agent_count {}

variable agent_prefix {}
