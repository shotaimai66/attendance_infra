resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.r_prefix}"
}
