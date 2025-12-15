output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.page_visits.name
}

output "table_arn" {
  description = "ARN de la tabla DynamoDB"
  value       = aws_dynamodb_table.page_visits.arn
}

output "table_id" {
  description = "ID de la tabla DynamoDB"
  value       = aws_dynamodb_table.page_visits.id
}
