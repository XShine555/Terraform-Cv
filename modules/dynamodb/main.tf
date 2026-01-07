# Tabla DynamoDB para contador de visitas
resource "aws_dynamodb_table" "page_visits" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand pricing
  hash_key     = "page_id"

  attribute {
    name = "page_id"
    type = "S" # String
  }

  # Habilitar point-in-time recovery (opcional pero recomendado)
  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name = var.table_name
      Type = "DynamoDB-Table"
    }
  )
}
