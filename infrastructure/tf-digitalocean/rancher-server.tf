# rancher-server.tf - spin up a rancher server with letsencrypt and route53 dns

data "template_file" "rancher_server_user_data" {
  template = "${file("${path.module}/server-cloud-config.yml")}"

  vars = {
    server_name = "${var.server_name}.${var.domain}"
    email       = "${var.email}"
    staging     = "${var.staging}"
  }
}

resource "digitalocean_droplet" "rancher_server" {
  image    = "rancheros"
  name     = "${var.me}-training-rancher-server"
  region   = "${var.do_region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.ssh_key.id}"]

  tags = ["${digitalocean_tag.rancher_server.id}"]

  user_data = "${data.template_file.rancher_server_user_data.rendered}"
}

resource "digitalocean_firewall" "rancher_server" {
  name = "rancher-server"

  droplet_ids = ["${digitalocean_droplet.rancher_server.id}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["${chomp(data.http.my_ip.body)}/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["${chomp(data.http.my_ip.body)}/32"]
      source_tags      = ["${digitalocean_tag.rancher_agent.name}"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["${chomp(data.http.my_ip.body)}/32"]
      source_tags      = ["${digitalocean_tag.rancher_agent.name}"]
    },
  ]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}

resource "aws_route53_record" "rancher_server_public" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "${var.server_name}.${var.domain}."
  type    = "A"
  ttl     = "300"
  records = ["${digitalocean_droplet.rancher_server.ipv4_address}"]
}
