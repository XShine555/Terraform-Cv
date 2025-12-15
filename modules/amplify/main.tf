# Crear aplicación de Amplify
resource "aws_amplify_app" "app" {
  name       = var.app_name
  repository = var.repository_url

  # Token de acceso de GitHub (opcional si usas GitHub App)
  access_token = var.github_token

  # Build settings para HTML estático
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        build:
          commands: []
      artifacts:
        baseDirectory: .
        files:
          - '**/*'
      cache:
        paths: []
  EOT

  # Variables de entorno
  environment_variables = var.environment_variables

  # Configuración de dominio personalizado
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  # Habilitar auto branch deletion
  enable_branch_auto_deletion = true

  tags = merge(
    var.tags,
    {
      Name = var.app_name
      Type = "Amplify-App"
    }
  )
}

# Crear rama de Amplify
resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.app.id
  branch_name = var.branch_name

  # Habilitar auto build
  enable_auto_build = true

  # Framework para HTML estático
  framework = "Web"

  stage = var.stage

  tags = merge(
    var.tags,
    {
      Name   = "${var.app_name}-${var.branch_name}"
      Type   = "Amplify-Branch"
      Branch = var.branch_name
    }
  )
}

# Configurar dominio personalizado con certificado ACM
resource "aws_amplify_domain_association" "domain" {
  app_id      = aws_amplify_app.app.id
  domain_name = var.domain_name

  # Esperar a que la rama esté lista
  depends_on = [aws_amplify_branch.master]

  # Configurar subdominio
  sub_domain {
    branch_name = aws_amplify_branch.master.branch_name
    prefix      = ""
  }

  # Esperar a que el certificado ACM esté validado
  wait_for_verification = true
}

# Trigger automático de deployment después de crear/actualizar la rama
resource "null_resource" "trigger_deployment" {
  count = var.enable_auto_deployment ? 1 : 0

  triggers = {
    branch_id  = aws_amplify_branch.master.branch_name
    build_spec = md5(aws_amplify_app.app.build_spec)
  }

  provisioner "local-exec" {
    command = "aws amplify start-job --app-id ${aws_amplify_app.app.id} --branch-name ${aws_amplify_branch.master.branch_name} --job-type RELEASE --region ${data.aws_region.current.name}"
    
    # Ignorar errores si ya hay un job corriendo
    on_failure = continue
  }

  depends_on = [aws_amplify_branch.master, aws_amplify_domain_association.domain]
}

# Data source para obtener la región actual
data "aws_region" "current" {}
