resource "aws_ecs_cluster" "cluster" {
  name = "${var.r_prefix}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.r_prefix}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" # Fargateを使う場合は「awsvpc」で固定
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = 512
  memory                   = 1024
  container_definitions    = "${file("./task-definitions/task-definition.json")}"
}

resource "aws_ecs_service" "service" {
  cluster                            = "${aws_ecs_cluster.cluster.id}"
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  name                               = "${var.r_prefix}-service"
  task_definition                    = "${aws_ecs_task_definition.app.arn}"
  desired_count                      = 1 # 常に1つのタスクが稼働する状態にする
  health_check_grace_period_seconds  = 1000

  // deployやautoscaleで動的に変化する値を差分だしたくないので無視する
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer,
    ]
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_blue.arn}"
    container_name   = "${var.r_prefix}"
    container_port   = 3000
  }

  network_configuration {
    subnets          = [
      aws_subnet.public_subnet_1a.id,
      aws_subnet.public_subnet_1c.id
    ]
    security_groups  = [
      aws_security_group.sg_app.id,
      aws_security_group.sg_db.id
    ]
    assign_public_ip = "true"
  }
}