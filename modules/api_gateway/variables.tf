variable "api_name" {
  description = "Nombre de la API Gateway"
  type        = string
}

variable "stage_name" {
  description = "Nombre del stage de API Gateway"
  type        = string
  default     = "prod"
}

variable "get_visits_lambda_invoke_arn" {
  description = "Invoke ARN de la función Lambda get_visits"
  type        = string
}

variable "increment_visits_lambda_invoke_arn" {
  description = "Invoke ARN de la función Lambda increment_visits"
  type        = string
}

variable "get_visits_lambda_function_name" {
  description = "Nombre de la función Lambda get_visits"
  type        = string
}

variable "increment_visits_lambda_function_name" {
  description = "Nombre de la función Lambda increment_visits"
  type        = string
}

variable "tags" {
  description = "Tags para los recursos de API Gateway"
  type        = map(string)
  default     = {}
}
