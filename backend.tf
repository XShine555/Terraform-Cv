terraform {
  backend "s3" {
    bucket         = "terraform-state-iker-cv-2026"
    key            = "terraform-page/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"  # Comentado - no necesario si trabajas solo
  }
}
