variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "enable_point_in_time_recovery" {
  description = "Habilitar recuperación point-in-time"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}
