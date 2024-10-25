
# data "aws_db_instance" "main" {
#   db_instance_identifier = var.RDS_INSTANCE_IDENTIFIER
# }

# Lambda for automatically backup RDS to S3
resource "aws_lambda_function" "rds_to_s3_backup_lambda" {
  image_uri     = module.rds_to_s3_backup_image.ecr_image_url
  function_name = "${var.environment}-${var.product}-rds-to-s3-backup"
  description   = "${var.environment}-${var.product}-rds-to-s3-backup"
  architectures = ["x86_64"]
  package_type  = "Image"
  timeout       = 900
  memory_size   = 1024
  publish       = true
  role          = aws_iam_role.rds_to_s3_backup_lambda.arn

  vpc_config {
    subnet_ids         = [aws_subnet.global_subnet_a.id, aws_subnet.global_subnet_b.id]
    security_group_ids = [aws_security_group.global_sg.id]
  }

  tracing_config {
    mode = "Active"
  }
  image_config {
    command = ["index.handler"]
  }
  environment {
    variables = {
      ENVIRONMENT          = local.environment
      REGION               = var.region
      DATABASE_NAME        = var.DATABASE_NAME
      DATABASE_PASSWORD    = var.DATABASE_PASSWORD
      RDS_BACKUP_S3_BUCKET = var.RDS_BACKUP_S3_BUCKET

    }
  }

  depends_on = [module.rds_to_s3_backup_image]
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_to_s3_backup_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
}