# Usar el rol LabRole existente en AWS Academy (no se puede crear roles)
data "aws_iam_role" "lab_role" {
  name = var.lambda_execution_role_name
}

# Crear archivo ZIP para get_visits
data "archive_file" "get_visits_zip" {
  type        = "zip"
  source_file = "${path.module}/functions/get_visits.py"
  output_path = "${path.module}/functions/get_visits.zip"
}

# Lambda function para obtener visitas
resource "aws_lambda_function" "get_visits" {
  filename         = data.archive_file.get_visits_zip.output_path
  function_name    = "${var.function_name_prefix}-get-visits"
  role            = data.aws_iam_role.lab_role.arn
  handler         = "get_visits.lambda_handler"
  source_code_hash = data.archive_file.get_visits_zip.output_base64sha256
  runtime         = "python3.11"
  timeout         = 10

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.function_name_prefix}-get-visits"
      Type = "Lambda-Function"
    }
  )
}

# Crear archivo ZIP para increment_visits
data "archive_file" "increment_visits_zip" {
  type        = "zip"
  source_file = "${path.module}/functions/increment_visits.py"
  output_path = "${path.module}/functions/increment_visits.zip"
}

# Lambda function para incrementar visitas
resource "aws_lambda_function" "increment_visits" {
  filename         = data.archive_file.increment_visits_zip.output_path
  function_name    = "${var.function_name_prefix}-increment-visits"
  role            = data.aws_iam_role.lab_role.arn
  handler         = "increment_visits.lambda_handler"
  source_code_hash = data.archive_file.increment_visits_zip.output_base64sha256
  runtime         = "python3.11"
  timeout         = 10

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.function_name_prefix}-increment-visits"
      Type = "Lambda-Function"
    }
  )
}
