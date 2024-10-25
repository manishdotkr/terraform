# Lambda for automatically backup RDS to S3
resource "aws_ecr_repository" "rds_to_s3_backup" {
  name                 = "${local.environment}-${local.namespace}-rds-to-s3-backup"
  image_tag_mutability = "MUTABLE"
}

module "rds_to_s3_backup_image" {
  source             = "./modules/rds-to-s3-backup"
  dockerfile_folder  = "../lambda/rds-to-s3-backup/"
  docker_image_tag   = var.COMMIT_HASH
  aws_region         = data.aws_region.current.id
  ecr_repository_url = aws_ecr_repository.rds_to_s3_backup.repository_url
}