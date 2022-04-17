
locals {
  name            = "kojitechs-${replace(basename(var.component_name), "-", "-")}"
  database_subnet = aws_subnet.database_sub.*.id
  private_cidrs   = aws_subnet.priv_sub.*.cidr_block
  vpc_cidrs       = aws_vpc.Kojitechs[0].cidr_block
}

resource "aws_security_group" "db_sg" {
  name        = "${var.component_name}_db_sg"
  description = "Allow app from self"
  vpc_id      = local.vpc_id

  ingress {
    description     = "Allow app from self"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.component_name}_db_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

module "aurora" {
  source = "git::https://github.com/Bkoji1150/aws-rdscluster-kojitechs-tf.git"

  name           = local.name
  engine         = "aurora-mysql"
  engine_version = "5.7.12"
  instances = {
    1 = {
      instance_class      = "db.r5.large"
      publicly_accessible = false
    }
    1 = {
      identifier     = format("%s-%s", "kojitechs-${var.component_name}", "reader-instance")
      instance_class = "db.r5.xlarge"
      promotion_tier = 15
    }
  }
  vpc_id                 = local.vpc_id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  create_db_subnet_group = true
  create_security_group  = false
  subnets                = local.database_subnet

  iam_database_authentication_enabled = true
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.example.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  database_name                   = "webappdb"
  master_username                 = "dbadmin"
}

resource "aws_db_parameter_group" "example" {
  name        = "${local.name}-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-aurora-db-57-parameter-group"

}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${local.name}-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-aurora-57-cluster-parameter-group"

}
