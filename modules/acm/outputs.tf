output "certificate_arn" {
  description = "ARN del certificado ACM"
  value       = aws_acm_certificate.subdomain.arn
}

output "certificate_id" {
  description = "ID del certificado ACM"
  value       = aws_acm_certificate.subdomain.id
}

output "certificate_status" {
  description = "Estado del certificado ACM"
  value       = aws_acm_certificate.subdomain.status
}

output "certificate_domain" {
  description = "Dominio del certificado ACM"
  value       = aws_acm_certificate.subdomain.domain_name
}

output "certificate_sans" {
  description = "Subject Alternative Names del certificado"
  value       = aws_acm_certificate.subdomain.subject_alternative_names
}

output "validation_records" {
  description = "Registros de validación DNS creados"
  value = [
    for record in aws_route53_record.cert_validation : {
      name    = record.name
      type    = record.type
      records = record.records
    }
  ]
}
