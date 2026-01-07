# Módulo Route 53 - Hosted Zone para el subdominio intermedio
module "route53" {
  source = "./modules/route53"

  domain_name            = var.domain_name
  intermediate_subdomain = var.intermediate_subdomain
  subdomain              = var.subdomain
  tags                   = var.tags
}

# Módulo Cloudflare - NS records para delegar el subdominio intermedio a Route 53
module "cloudflare" {
  source = "./modules/cloudflare"

  domain_name            = var.domain_name
  intermediate_subdomain = var.intermediate_subdomain
  cloudflare_zone_id     = var.cloudflare_zone_id
  route53_nameservers    = module.route53.name_servers

  depends_on = [module.route53]
}

# Módulo ACM - Certificado SSL/TLS para el dominio completo
module "acm" {
  source = "./modules/acm"

  domain_name            = var.domain_name
  intermediate_subdomain = var.intermediate_subdomain
  subdomain              = var.subdomain
  route53_zone_id        = module.route53.zone_id
  tags                   = var.tags

  depends_on = [module.route53]
}

# Módulo Amplify - Hosting de la aplicación con dominio personalizado
module "amplify" {
  source = "./modules/amplify"

  app_name        = var.amplify_app_name
  repository_url  = var.amplify_repository_url
  github_token    = var.amplify_github_token
  branch_name     = var.amplify_branch
  domain_name     = module.route53.full_domain
  tags            = var.tags

  # Activar deployment automático al crear/actualizar
  enable_auto_deployment = true

  environment_variables = {
    REPOSITORY_URL = var.amplify_repository_url
    SUBDOMAIN      = var.subdomain
  }

  depends_on = [module.route53, module.cloudflare, module.acm]
}

# Módulo DynamoDB - Tabla de contador de visitas
module "dynamodb" {
  source = "./modules/dynamodb"

  table_name                    = var.dynamodb_table_name
  enable_point_in_time_recovery = var.dynamodb_enable_pitr
  tags                          = var.tags
}

# Módulo Lambda - Funciones para gestionar visitas
module "lambda" {
  source = "./modules/lambda"

  function_name_prefix        = var.lambda_function_prefix
  lambda_execution_role_name  = var.lambda_execution_role
  dynamodb_table_name         = module.dynamodb.table_name
  dynamodb_table_arn          = module.dynamodb.table_arn
  tags                        = var.tags

  depends_on = [module.dynamodb]
}

# Módulo API Gateway - REST API para contador de visitas
module "api_gateway" {
  source = "./modules/api_gateway"

  api_name                              = var.api_gateway_name
  stage_name                            = var.api_gateway_stage
  get_visits_lambda_invoke_arn          = module.lambda.get_visits_invoke_arn
  increment_visits_lambda_invoke_arn    = module.lambda.increment_visits_invoke_arn
  get_visits_lambda_function_name       = module.lambda.get_visits_function_name
  increment_visits_lambda_function_name = module.lambda.increment_visits_function_name
  tags                                  = var.tags

  depends_on = [module.lambda]
}
