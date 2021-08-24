variable "aws_account_id" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}
variable "domain" {}

# 作成するリソースのプレフィックス
variable "r_prefix" {
  default = "rails"
}