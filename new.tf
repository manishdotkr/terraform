resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["74F3A68F16524F15424927704C9506F55A9316BD"] 

  tags = {
    environment = var.environment
    product     = var.product
    service     = var.service
  }
}
resource "aws_iam_role" "github_assume_role" {
  name = "${var.environment}-${var.product}-github-assume-updaterole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.githubUserName}/${var.githubRepoName}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_send_command_policy" {
  name   = "${var.environment}-${var.product}-github-send-command-policy2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:CancelCommand", "ssm:SendCommand", "ssm:GetCommandInvocation"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_github_send_command_policy" {
  role       = aws_iam_role.github_assume_role.name
  policy_arn = aws_iam_policy.github_send_command_policy.arn
}

output "github_assume_role_arn" {
  description = "ARN of the GitHubAssumeRole IAM Role"
  value       = aws_iam_role.github_assume_role.arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Identity Provider"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}
