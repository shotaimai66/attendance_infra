resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.r_prefix}-20210401-alb-logs" # S3バケット名はグローバルで一意である必要があるので、適当に日付などを付けて差別化を図ると良いかも。
}
