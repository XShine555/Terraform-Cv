output "ns_record" {
  description = "NS record creado en Cloudflare (SOA principal)"
  value = {
    name    = cloudflare_record.ns_record.name
    content = cloudflare_record.ns_record.content
    type    = cloudflare_record.ns_record.type
    id      = cloudflare_record.ns_record.id
  }
}

output "subdomain_delegation" {
  description = "Información de la delegación del subdominio"
  value = {
    subdomain   = var.intermediate_subdomain
    full_domain = "${var.intermediate_subdomain}.${var.domain_name}"
    nameservers = var.route53_nameservers
  }
}
