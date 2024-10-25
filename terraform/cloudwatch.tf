resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "${var.environment}-${var.product}-rds-to-s3-backup-lambda-trigger"
  description         = "Triggers the RDS to S3 Backup Lambda every day at 11 AM"
  schedule_expression = "cron(0 6 * * ? *)" # 11 AM IST
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger.name
  target_id = "${var.environment}-${var.product}-rds-to-s3-backup-target"
  arn       = aws_lambda_function.rds_to_s3_backup_lambda.arn
}