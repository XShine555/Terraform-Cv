variable "domain_name" {
  description = "Dominio principal"
  type        = string
}

variable "intermediate_subdomain" {
  description = "Subdominio intermedio para el Hosted Zone"
  type        = string
}

variable "subdomain" {
  description = "Subdominio final (dentro del Hosted Zone)"
  type        = string
}

variable "tags" {
  description = "Tags para los recursos de Route 53"
  type        = map(string)
  default     = {}
}
