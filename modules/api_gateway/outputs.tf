output "api_id" {
  description = "ID de la API Gateway"
  value       = aws_api_gateway_rest_api.visits_api.id
}

output "api_arn" {
  description = "ARN de la API Gateway"
  value       = aws_api_gateway_rest_api.visits_api.arn
}

output "api_execution_arn" {
  description = "ARN de ejecución de la API Gateway"
  value       = aws_api_gateway_rest_api.visits_api.execution_arn
}

output "api_endpoint" {
  description = "URL base de la API Gateway"
  value       = aws_api_gateway_stage.visits_api.invoke_url
}

output "get_visits_endpoint" {
  description = "Endpoint completo para obtener visitas"
  value       = "${aws_api_gateway_stage.visits_api.invoke_url}/visits/{page_id}"
}

output "increment_visits_endpoint" {
  description = "Endpoint completo para incrementar visitas"
  value       = "${aws_api_gateway_stage.visits_api.invoke_url}/visits/{page_id}"
}
