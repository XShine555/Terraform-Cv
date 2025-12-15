output "zone_id" {
  description = "ID del Hosted Zone"
  value       = aws_route53_zone.subdomain.zone_id
}

output "name_servers" {
  description = "Name servers del Hosted Zone"
  value       = aws_route53_zone.subdomain.name_servers
}

output "hosted_zone_name" {
  description = "Nombre del Hosted Zone"
  value       = aws_route53_zone.subdomain.name
}

output "full_domain" {
  description = "Dominio completo del subdominio final"
  value       = "${var.subdomain}.${aws_route53_zone.subdomain.name}"
}

output "zone_arn" {
  description = "ARN del Hosted Zone"
  value       = aws_route53_zone.subdomain.arn
}
