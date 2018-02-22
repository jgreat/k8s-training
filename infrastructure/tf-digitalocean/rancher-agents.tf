# rancher-agents.tf - 3 servers with required images pre-pulled

data "template_file" "rancher_agent_user_data" {
  template = "${file("${path.module}/agent-cloud-config.yml")}"

  vars = {}
}

resource "digitalocean_droplet" "rancher_agent" {
  count    = "${var.agent_count}"
  image    = "rancheros"
  name     = "${var.agent_prefix}-${count.index}"
  region   = "${var.do_region}"
  size     = "s-6vcpu-16gb"
  ssh_keys = ["${digitalocean_ssh_key.ssh_key.id}"]

  tags = ["${digitalocean_tag.rancher_agent.id}"]

  user_data = "${data.template_file.rancher_agent_user_data.rendered}"
}

resource "digitalocean_firewall" "rancher_agent" {
  name = "rancher-agent"

  droplet_ids = ["${digitalocean_droplet.rancher_agent.*.id}"]

  inbound_rule = [
    {
      protocol    = "tcp"
      port_range  = "1-65535"
      source_tags = ["${digitalocean_tag.rancher_agent.name}"]
    },
    {
      protocol    = "udp"
      port_range  = "1-65535"
      source_tags = ["${digitalocean_tag.rancher_agent.name}"]
    },
    {
      protocol    = "tcp"
      port_range  = "10250"
      source_tags = ["${digitalocean_tag.rancher_server.name}"]
    },
    {
      protocol    = "tcp"
      port_range  = "10255"
      source_tags = ["${digitalocean_tag.rancher_server.name}"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "30000-32767"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["${chomp(data.http.my_ip.body)}/32"]
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

resource "aws_route53_record" "rancher_agents_public" {
  count   = "${var.agent_count}"
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "${digitalocean_droplet.rancher_agent.*.name[count.index]}"
  type    = "A"
  ttl     = "300"
  records = ["${digitalocean_droplet.rancher_agent.*.ipv4_address[count.index]}"]
}

resource "aws_route53_record" "rancher_game" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "game"
  type    = "A"
  ttl     = "300"
  records = ["${digitalocean_droplet.rancher_agent.*.ipv4_address}"]
}

resource "aws_route53_record" "rancher_nginx" {
  zone_id = "${data.aws_route53_zone.dns_zone.zone_id}"
  name    = "nginx"
  type    = "A"
  ttl     = "300"
  records = ["${digitalocean_droplet.rancher_agent.*.ipv4_address}"]
}