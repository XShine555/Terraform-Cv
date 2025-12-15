output "route53_zone_id" {
  description = "ID del Hosted Zone de Route 53"
  value       = module.route53.zone_id
}

output "route53_name_servers" {
  description = "Name servers del Hosted Zone de Route 53"
  value       = module.route53.name_servers
}

output "full_domain" {
  description = "Dominio completo del subdominio"
  value       = module.route53.full_domain
}

output "cloudflare_ns_records" {
  description = "NS records creados en Cloudflare"
  value       = module.cloudflare.ns_records
}

output "acm_certificate_arn" {
  description = "ARN del certificado ACM"
  value       = module.acm.certificate_arn
}

output "acm_certificate_status" {
  description = "Estado del certificado ACM"
  value       = module.acm.certificate_status
}

output "acm_certificate_domain" {
  description = "Dominio del certificado ACM"
  value       = module.acm.certificate_domain
}

output "amplify_app_id" {
  description = "ID de la aplicación de Amplify"
  value       = module.amplify.app_id
}

output "amplify_default_url" {
  description = "URL por defecto de Amplify"
  value       = module.amplify.branch_url
}

output "amplify_custom_domain_url" {
  description = "URL del dominio personalizado de Amplify"
  value       = module.amplify.custom_domain_url
}

output "amplify_domain_verification" {
  description = "Registro de verificación del dominio de Amplify"
  value       = module.amplify.domain_verification_record
}

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = module.dynamodb.table_name
}

output "api_gateway_endpoint" {
  description = "URL base de la API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "api_get_visits_endpoint" {
  description = "Endpoint para obtener visitas (GET)"
  value       = module.api_gateway.get_visits_endpoint
}

output "api_increment_visits_endpoint" {
  description = "Endpoint para incrementar visitas (POST)"
  value       = module.api_gateway.increment_visits_endpoint
}
