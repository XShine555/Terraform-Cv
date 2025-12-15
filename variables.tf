variable "aws_region" {
  description = "AWS region donde se crearán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Dominio principal gestionado en Cloudflare"
  type        = string
}

variable "intermediate_subdomain" {
  description = "Subdominio intermedio que será el Hosted Zone en Route 53 (ej: aws10)"
  type        = string
}

variable "subdomain" {
  description = "Subdominio final dentro del Hosted Zone (ej: cv)"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID de Cloudflare del dominio principal"
  type        = string
}

variable "cloudflare_api_token" {
  description = "API Token de Cloudflare con permisos de Zone:Edit y DNS:Edit"
  type        = string
  sensitive   = true
}

variable "amplify_app_name" {
  description = "Nombre de la aplicación de Amplify"
  type        = string
  default     = "cv-portfolio"
}

variable "amplify_repository_url" {
  description = "URL del repositorio público de GitHub"
  type        = string
}

variable "amplify_github_token" {
  description = "Personal Access Token de GitHub para Amplify (opcional si usas GitHub App)"
  type        = string
  sensitive   = true
  default     = null
}

variable "amplify_branch" {
  description = "Rama del repositorio a desplegar"
  type        = string
  default     = "master"
}

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB para contador de visitas"
  type        = string
  default     = "page-visits"
}

variable "dynamodb_enable_pitr" {
  description = "Habilitar point-in-time recovery para DynamoDB"
  type        = bool
  default     = false
}

variable "api_gateway_name" {
  description = "Nombre de la API Gateway"
  type        = string
  default     = "visits-api"
}

variable "api_gateway_stage" {
  description = "Stage de la API Gateway"
  type        = string
  default     = "prod"
}

variable "lambda_function_prefix" {
  description = "Prefijo para los nombres de funciones Lambda"
  type        = string
  default     = "visits"
}

variable "lambda_execution_role" {
  description = "Nombre del rol IAM para Lambda (usar LabRole en AWS Academy)"
  type        = string
  default     = "LabRole"
}

variable "tags" {
  description = "Tags comunes para todos los recursos de AWS"
  type        = map(string)
  default = {
    Project     = "CV-Infrastructure"
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}
