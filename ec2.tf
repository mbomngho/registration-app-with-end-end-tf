
locals {
  subnet_id = [aws_subnet.priv_sub[0].id, aws_subnet.priv_sub[1].id]
  Name      = ["app_instance_1", "app_instance_2"]
  mysql     = data.aws_secretsmanager_secret_version.rds_secret_target
}

data "aws_secretsmanager_secret_version" "rds_secret_target" {
  depends_on = [module.aurora]
  secret_id  = module.aurora.secrets_version.secret_id
}

resource "aws_instance" "web" {

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet[0].id
  user_data              = file("${path.module}/template/app1-http.sh")
  vpc_security_group_ids = [aws_security_group.web_server.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.bastion_instance.id

  tags = {
    Name = "web_instance"
  }
}

resource "aws_instance" "registration_app" {
  depends_on = [module.aurora]
  count      = length(local.Name)

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  subnet_id              = local.subnet_id[count.index]
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
    user_data, ]
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

#resource "aws_lb_target_group_attachment" "register_app" {
#  count = length(local.Name)
#  target_group_arn = aws_lb_target_group.register_app.arn
#  target_id = aws_instance.registration_app[count.index].id
#  port   = 8080
#}

#resource "aws_lb_target_group_attachment" "front_end" {
#  target_group_arn = aws_lb_target_group.kojitech-targetgroup.arn
#  target_id = aws_instance.web.id
#  port   = 8080
#}
