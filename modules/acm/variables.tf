variable "domain_name" {
  description = "Dominio principal"
  type        = string
}

variable "intermediate_subdomain" {
  description = "Subdominio intermedio"
  type        = string
}

variable "subdomain" {
  description = "Subdominio final para el certificado"
  type        = string
}

variable "route53_zone_id" {
  description = "ID del Hosted Zone de Route 53 donde se crearán los registros de validación"
  type        = string
}

variable "tags" {
  description = "Tags para el certificado ACM"
  type        = map(string)
  default     = {}
}
