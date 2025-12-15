# Crear NS records en Cloudflare para delegar el subdominio intermedio a Route 53
# Route 53 siempre devuelve 4 nameservers, por eso usamos índices 0-3
resource "cloudflare_record" "ns_record_0" {
  zone_id = var.cloudflare_zone_id
  name    = var.intermediate_subdomain
  content = var.route53_nameservers[0]
  type    = "NS"
  ttl     = 3600
  comment = "NS record para delegar ${var.intermediate_subdomain}.${var.domain_name} a Route 53"
}

resource "cloudflare_record" "ns_record_1" {
  zone_id = var.cloudflare_zone_id
  name    = var.intermediate_subdomain
  content = var.route53_nameservers[1]
  type    = "NS"
  ttl     = 3600
  comment = "NS record para delegar ${var.intermediate_subdomain}.${var.domain_name} a Route 53"
}

resource "cloudflare_record" "ns_record_2" {
  zone_id = var.cloudflare_zone_id
  name    = var.intermediate_subdomain
  content = var.route53_nameservers[2]
  type    = "NS"
  ttl     = 3600
  comment = "NS record para delegar ${var.intermediate_subdomain}.${var.domain_name} a Route 53"
}

resource "cloudflare_record" "ns_record_3" {
  zone_id = var.cloudflare_zone_id
  name    = var.intermediate_subdomain
  content = var.route53_nameservers[3]
  type    = "NS"
  ttl     = 3600
  comment = "NS record para delegar ${var.intermediate_subdomain}.${var.domain_name} a Route 53"
}
