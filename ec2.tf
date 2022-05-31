
locals {
  subnet_id = [aws_subnet.priv_sub[0].id, aws_subnet.priv_sub[1].id]
  Name      = ["app_instance_1", "app_instance_2"]
  mysql     = data.aws_secretsmanager_secret_version.rds_secret_target

  instances = {
    app1_instance = {
      instance_type = "t2.micro"
      subnet_id     = aws_subnet.priv_sub[0].id
      user_data     = file("${path.module}/template/app1-http.sh")
    }
    app2_instance = {
      instance_type = "t2.xlarge"
      subnet_id     = aws_subnet.priv_sub[1].id
      user_data     = file("${path.module}/template/app2-http.sh")
    }
  }
}

data "aws_secretsmanager_secret_version" "rds_secret_target" {

  depends_on = [module.aurora]
  secret_id  = module.aurora.secrets_version
}

/*
resource "aws_instance" "web_test" {
  for_each = var.environment != null ? local.instances : {}

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  user_data              = each.value.user_data
  vpc_security_group_ids = [aws_security_group.web_server.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.bastion_instance.id

  tags = {
    Name = each.key
  }
}
*/

resource "aws_instance" "web" {
  for_each = {
    for id, instances in local.instances : id => instances
    if(var.environment != null && local.create_vpc)
  }

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  user_data              = each.value.user_data
  vpc_security_group_ids = [aws_security_group.web_server.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.bastion_instance.id

  tags = {
    Name = each.key
  }
}

resource "aws_instance" "registration_app" {
  depends_on = [module.aurora]
  count      = length(local.Name)

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  subnet_id              = element(local.subnet_id, count.index)
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.bastion_instance.id
  user_data = templatefile("${path.root}/template/app3-ums-install.tmpl",
    {
      endpoint    = jsondecode(local.mysql.secret_string)["endpoint"]
      port        = jsondecode(local.mysql.secret_string)["port"]
      db_name     = jsondecode(local.mysql.secret_string)["dbname"]
      db_user     = jsondecode(local.mysql.secret_string)["username"]
      db_password = jsondecode(local.mysql.secret_string)["password"]
    }
  )
  tags = {
    Name = local.Name[count.index]
  }
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "aws_key_pair" "bastion_instance" {
  key_name   = "jenkins_ssh_file"
  public_key = file("${path.module}/template/jenkins_ssh_file.pub")
}

resource "aws_ssm_parameter" "ssm_kp" {
  name  = format("%s-%s", var.component_name, "ssm-kp")
  type  = "SecureString"
  value = " "
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
