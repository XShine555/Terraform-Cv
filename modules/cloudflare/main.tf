# Crear registro NS en Cloudflare para delegar el subdominio intermedio a Route 53
# Solo se necesita el SOA (Start of Authority) principal
resource "cloudflare_record" "ns_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.intermediate_subdomain
  content = var.route53_nameservers[0] # SOA principal
  type    = "NS"
  ttl     = 3600
  comment = "NS record para delegar ${var.intermediate_subdomain}.${var.domain_name} a Route 53"
}

