output "ns_records" {
  description = "NS records creados en Cloudflare"
  value = [
    {
      name    = cloudflare_record.ns_record_0.name
      content = cloudflare_record.ns_record_0.content
      type    = cloudflare_record.ns_record_0.type
      id      = cloudflare_record.ns_record_0.id
    },
    {
      name    = cloudflare_record.ns_record_1.name
      content = cloudflare_record.ns_record_1.content
      type    = cloudflare_record.ns_record_1.type
      id      = cloudflare_record.ns_record_1.id
    },
    {
      name    = cloudflare_record.ns_record_2.name
      content = cloudflare_record.ns_record_2.content
      type    = cloudflare_record.ns_record_2.type
      id      = cloudflare_record.ns_record_2.id
    },
    {
      name    = cloudflare_record.ns_record_3.name
      content = cloudflare_record.ns_record_3.content
      type    = cloudflare_record.ns_record_3.type
      id      = cloudflare_record.ns_record_3.id
    }
  ]
}

output "subdomain_delegation" {
  description = "Información de la delegación del subdominio"
  value = {
    subdomain   = var.intermediate_subdomain
    full_domain = "${var.intermediate_subdomain}.${var.domain_name}"
    nameservers = var.route53_nameservers
  }
}
