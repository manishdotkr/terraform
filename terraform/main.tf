provider "aws" {
  region      = "us-east-2"
  max_retries = 10

  default_tags {
    tags = local.common_aws_tags
  }
}

data "aws_region" "current" {}

locals {
  region      = data.aws_region.current.id
  environment = lower(var.DEFAULT_WORKSPACE)
  namespace   = "testing"

  common_aws_tags = {
    Environment          = terraform.workspace
    Owner                = "LegalTech Dev Team"
    RepositoryName       = "legaltech-infra"
    Project              = "Legaltech Authentication"
    Name                 = "Legaltech Authentication"
    Organization         = "LegaltechHub"
    GeographicDeployment = "US"
    Description          = "Legaltech Authentication"
  }
}
