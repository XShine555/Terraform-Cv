output "app_id" {
  description = "ID de la aplicación de Amplify"
  value       = aws_amplify_app.app.id
}

output "app_arn" {
  description = "ARN de la aplicación de Amplify"
  value       = aws_amplify_app.app.arn
}

output "default_domain" {
  description = "Dominio por defecto de Amplify"
  value       = aws_amplify_app.app.default_domain
}

output "branch_name" {
  description = "Nombre de la rama desplegada"
  value       = aws_amplify_branch.master.branch_name
}

output "branch_url" {
  description = "URL de la rama de Amplify"
  value       = "https://${aws_amplify_branch.master.branch_name}.${aws_amplify_app.app.default_domain}"
}

output "custom_domain" {
  description = "Dominio personalizado configurado"
  value       = var.domain_name
}

output "custom_domain_url" {
  description = "URL del dominio personalizado"
  value       = "https://${var.domain_name}"
}

output "domain_association_arn" {
  description = "ARN de la asociación de dominio"
  value       = aws_amplify_domain_association.domain.arn
}

output "domain_verification_record" {
  description = "Registro de verificación del dominio"
  value       = aws_amplify_domain_association.domain.certificate_verification_dns_record
}
