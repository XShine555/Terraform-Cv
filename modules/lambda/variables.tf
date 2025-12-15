variable "function_name_prefix" {
  description = "Prefijo para los nombres de las funciones Lambda"
  type        = string
}

variable "lambda_execution_role_name" {
  description = "Nombre del rol IAM existente para Lambda (LabRole en AWS Academy)"
  type        = string
  default     = "LabRole"
}

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB"
  type        = string
}

variable "tags" {
  description = "Tags para los recursos Lambda"
  type        = map(string)
  default     = {}
}
