variable "app_name" {
  description = "Nombre de la aplicación de Amplify"
  type        = string
}

variable "repository_url" {
  description = "URL del repositorio de GitHub (público)"
  type        = string
}

variable "github_token" {
  description = "Personal Access Token de GitHub (opcional si usas GitHub App)"
  type        = string
  sensitive   = true
  default     = null
}

variable "branch_name" {
  description = "Nombre de la rama a desplegar"
  type        = string
  default     = "master"
}

variable "domain_name" {
  description = "Dominio personalizado completo para Amplify"
  type        = string
}

variable "environment_variables" {
  description = "Variables de entorno para la aplicación de Amplify"
  type        = map(string)
  default     = {}
}

variable "stage" {
  description = "Stage de la rama (PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST)"
  type        = string
  default     = "PRODUCTION"
}

variable "enable_auto_deployment" {
  description = "Habilitar deployment automático al aplicar cambios"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para los recursos de Amplify"
  type        = map(string)
  default     = {}
}
