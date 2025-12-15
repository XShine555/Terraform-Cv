variable "domain_name" {
  description = "Dominio principal en Cloudflare"
  type        = string
}

variable "intermediate_subdomain" {
  description = "Subdominio intermedio a delegar"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID de Cloudflare"
  type        = string
}

variable "route53_nameservers" {
  description = "Name servers de Route 53 para el subdominio"
  type        = list(string)
}
