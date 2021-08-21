# アプリ全体用
resource "aws_security_group" "sg_app" {
  name        = "${var.r_prefix}-sg-app"
  description = "${var.r_prefix}-sg-app"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-app"
  }
}

# ロードバランサー用
resource "aws_security_group" "sg_alb" {
  name        = "${var.r_prefix}-sg-alb"
  description = "${var.r_prefix}-sg-alb"
  vpc_id      = "${aws_vpc.vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-alb"
  }
}

resource "aws_security_group_rule" "inbound_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = "${aws_security_group.sg_alb.id}"
}

# データベース用
resource "aws_security_group" "sg_db" {
  name        = "${var.r_prefix}-sg-db"
  description = "${var.r_prefix}-sg-db"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-db"
  }
}