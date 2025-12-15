# Solicitar certificado SSL/TLS en ACM para el subdominio completo
resource "aws_acm_certificate" "subdomain" {
  domain_name       = "${var.subdomain}.${var.intermediate_subdomain}.${var.domain_name}"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.subdomain}.${var.intermediate_subdomain}.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name   = "${var.subdomain}.${var.intermediate_subdomain}.${var.domain_name}"
      Type   = "ACM-Certificate"
      Domain = "${var.subdomain}.${var.intermediate_subdomain}.${var.domain_name}"
    }
  )
}

# Crear registros de validación DNS en Route 53 automáticamente
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.subdomain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# Validación del certificado
resource "aws_acm_certificate_validation" "subdomain" {
  certificate_arn         = aws_acm_certificate.subdomain.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "10m"
  }
}
