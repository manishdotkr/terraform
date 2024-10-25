data "aws_iam_policy" "aws_lambda_basic_execution_role" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "AWS_lambda_VPC_access_execution_role" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy" "amazon_api_gateway_push_to_cloudwatch_logs" {
  name = "AmazonAPIGatewayPushToCloudWatchLogs"
}
