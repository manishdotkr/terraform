variable "COMMIT_HASH" {
  type    = string
  default = "latest"
}

variable "DEFAULT_WORKSPACE" {
  type    = string
  default = "main"
}

variable "RDS_INSTANCE_IDENTIFIER" {
  type    = string
  default = "testdb"
}

variable "RDS_SECURITY_GROUP_ID" {
  type    = string
  default = "sg-0ccb53f6cc35c1a46"
}

variable "DATABASE_NAME" {
  type    = string
  default = "postgres"
}

variable "DATABASE_PASSWORD" {
  type    = string
  default = "password"
}

variable "RDS_BACKUP_S3_BUCKET" {
  type    = string
  default = "lth-backup"
}





variable "environment" {
  type    = string
  default = "main"
}

variable "product" {
  type    = string
  default = "lth"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "resource" {
  type    = string
  default = "manish"
}

variable "iac" {
  type    = string
  default = "terraform"
}






