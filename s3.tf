resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.aws_account_id}-alb-logs" # S3バケット名はグローバルで一意である必要があるので、適当に日付などを付けて差別化を図ると良いかも。
}

resource "aws_s3_bucket" "rails-s3" {
  bucket = "${var.aws_account_id}-for-rails-s3" # S3バケット名はグローバルで一意である必要があるので、適当に日付などを付けて差別化を図ると良いかも。
}

resource "aws_s3_bucket_public_access_block" "rails-s3" {
  bucket = aws_s3_bucket.rails-s3.id

  block_public_acls   = false
  block_public_policy = true
}