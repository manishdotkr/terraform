variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "environment" {
  type    = string
  default = "development"
}

variable "product" {
  type    = string
  default = "lth"
}

variable "service" {
  type    = string
  default = "iam-role"
}

variable "githubUserName" {
  type    = string
}

variable "githubRepoName" {
  type    = string
}