output "get_visits_function_name" {
  description = "Nombre de la función Lambda get_visits"
  value       = aws_lambda_function.get_visits.function_name
}

output "get_visits_function_arn" {
  description = "ARN de la función Lambda get_visits"
  value       = aws_lambda_function.get_visits.arn
}

output "get_visits_invoke_arn" {
  description = "Invoke ARN de la función Lambda get_visits"
  value       = aws_lambda_function.get_visits.invoke_arn
}

output "increment_visits_function_name" {
  description = "Nombre de la función Lambda increment_visits"
  value       = aws_lambda_function.increment_visits.function_name
}

output "increment_visits_function_arn" {
  description = "ARN de la función Lambda increment_visits"
  value       = aws_lambda_function.increment_visits.arn
}

output "increment_visits_invoke_arn" {
  description = "Invoke ARN de la función Lambda increment_visits"
  value       = aws_lambda_function.increment_visits.invoke_arn
}

output "lambda_role_arn" {
  description = "ARN del rol IAM de Lambda"
  value       = data.aws_iam_role.lab_role.arn
}
