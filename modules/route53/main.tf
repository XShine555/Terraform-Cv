# Crear Hosted Zone en Route 53 para el subdominio intermedio (aws10.ikerdemo.cat)
resource "aws_route53_zone" "subdomain" {
  name          = "${var.intermediate_subdomain}.${var.domain_name}"
  comment       = "Hosted Zone para ${var.intermediate_subdomain}.${var.domain_name} - Gestionado por Terraform"
  force_destroy = true # Permite eliminar aunque contenga registros DNS

  tags = merge(
    var.tags,
    {
      Name = "${var.intermediate_subdomain}.${var.domain_name}"
      Type = "Route53-HostedZone"
    }
  )
}
