# API Gateway REST API
resource "aws_api_gateway_rest_api" "visits_api" {
  name        = var.api_name
  description = "API para gestionar contador de visitas"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.api_name
      Type = "API-Gateway"
    }
  )
}

# Resource /visits
resource "aws_api_gateway_resource" "visits" {
  rest_api_id = aws_api_gateway_rest_api.visits_api.id
  parent_id   = aws_api_gateway_rest_api.visits_api.root_resource_id
  path_part   = "visits"
}

# Resource /visits/{page_id}
resource "aws_api_gateway_resource" "page_id" {
  rest_api_id = aws_api_gateway_rest_api.visits_api.id
  parent_id   = aws_api_gateway_resource.visits.id
  path_part   = "{page_id}"
}

# GET /visits/{page_id}
resource "aws_api_gateway_method" "get_visits" {
  rest_api_id   = aws_api_gateway_rest_api.visits_api.id
  resource_id   = aws_api_gateway_resource.page_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_visits" {
  rest_api_id             = aws_api_gateway_rest_api.visits_api.id
  resource_id             = aws_api_gateway_resource.page_id.id
  http_method             = aws_api_gateway_method.get_visits.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_visits_lambda_invoke_arn
}

# POST /visits/{page_id}
resource "aws_api_gateway_method" "increment_visits" {
  rest_api_id   = aws_api_gateway_rest_api.visits_api.id
  resource_id   = aws_api_gateway_resource.page_id.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "increment_visits" {
  rest_api_id             = aws_api_gateway_rest_api.visits_api.id
  resource_id             = aws_api_gateway_resource.page_id.id
  http_method             = aws_api_gateway_method.increment_visits.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.increment_visits_lambda_invoke_arn
}

# CORS OPTIONS para GET
resource "aws_api_gateway_method" "options_get" {
  rest_api_id   = aws_api_gateway_rest_api.visits_api.id
  resource_id   = aws_api_gateway_resource.page_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_get" {
  rest_api_id = aws_api_gateway_rest_api.visits_api.id
  resource_id = aws_api_gateway_resource.page_id.id
  http_method = aws_api_gateway_method.options_get.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_get" {
  rest_api_id = aws_api_gateway_rest_api.visits_api.id
  resource_id = aws_api_gateway_resource.page_id.id
  http_method = aws_api_gateway_method.options_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_get" {
  rest_api_id = aws_api_gateway_rest_api.visits_api.id
  resource_id = aws_api_gateway_resource.page_id.id
  http_method = aws_api_gateway_method.options_get.http_method
  status_code = aws_api_gateway_method_response.options_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.options_get]
}

# Deployment
resource "aws_api_gateway_deployment" "visits_api" {
  rest_api_id = aws_api_gateway_rest_api.visits_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.visits.id,
      aws_api_gateway_resource.page_id.id,
      aws_api_gateway_method.get_visits.id,
      aws_api_gateway_method.increment_visits.id,
      aws_api_gateway_integration.get_visits.id,
      aws_api_gateway_integration.increment_visits.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.get_visits,
    aws_api_gateway_integration.increment_visits,
    aws_api_gateway_integration.options_get
  ]
}

# Stage
resource "aws_api_gateway_stage" "visits_api" {
  deployment_id = aws_api_gateway_deployment.visits_api.id
  rest_api_id   = aws_api_gateway_rest_api.visits_api.id
  stage_name    = var.stage_name

  tags = merge(
    var.tags,
    {
      Name = "${var.api_name}-${var.stage_name}"
      Type = "API-Gateway-Stage"
    }
  )
}

# Permisos para API Gateway invoke Lambda - get_visits
resource "aws_lambda_permission" "apigw_get_visits" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_visits_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.visits_api.execution_arn}/*/*"
}

# Permisos para API Gateway invoke Lambda - increment_visits
resource "aws_lambda_permission" "apigw_increment_visits" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.increment_visits_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.visits_api.execution_arn}/*/*"
}
