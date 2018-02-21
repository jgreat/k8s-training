# main.tf - providers and shared resources

# Set DIGITALOCEAN_TOKEN environment variable
provider "digitalocean" {}

# Use aws cli profile
provider "aws" {
  profile = "${var.aws_profile}"
  region  = "us-east-1"
}

resource "digitalocean_tag" "rancher_server" {
  name = "rancher_server"
}

resource "digitalocean_tag" "rancher_agent" {
  name = "rancher_agent"
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = "${var.me}"
  public_key = "${file(var.ssh_public_key_file)}"
}

# My domain is in route53
data "aws_route53_zone" "dns_zone" {
  name = "${var.domain}"
}

# Get My IP address to allow firewall access
data "http" "my_ip" {
  url = "http://v4.ifconfig.co"
}
