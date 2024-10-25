# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "build_and_push" {
  # Should trigger on every run
  triggers = {
    always_run = "${timestamp()}"
  }

  # See build.sh for more details
  provisioner "local-exec" {
    command     = "chmod +x ${path.module}/bin/build.sh; ${path.module}/bin/build.sh ${var.dockerfile_folder} ${var.ecr_repository_url}:${var.docker_image_tag} ${var.aws_region}"
    interpreter = ["/bin/bash", "-c"]
  }
}
