## operational-enviroment-vpc

This module was built VPC IN operational-enviroment-vpc[cookiecutter-microservice](https://github.com/Bkoji1150/registration-app-with-end-end--tf).

<!-- prettier-ignore-start -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 3.0.0 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 6.0.0 |
| <a name="module_aurora"></a> [aurora](#module\_aurora) | git::https://github.com/Bkoji1150/aws-rdscluster-kojitechs-tf.git | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_default_route_table.default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_eip.eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ssm_for_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm_attach_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.registration_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.bastion_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_nat_gateway.ngw_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_rds_cluster_parameter_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_route53_record.default_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route_table.route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.route_tables_ass](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.app_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.ssm_kp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.database_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.priv_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.Kojitechs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.amzlinux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.mydomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret_version.rds_secret_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | aws region | `string` | `"us-east-1"` | no |
| <a name="input_cidr_database"></a> [cidr\_database](#input\_cidr\_database) | list of database cidrs | `list(any)` | <pre>[<br>  "10.0.5.0/24",<br>  "10.0.7.0/24"<br>]</pre> | no |
| <a name="input_cidr_privsubnet"></a> [cidr\_privsubnet](#input\_cidr\_privsubnet) | list of private cidrs | `list(any)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_cidr_pubsubnet"></a> [cidr\_pubsubnet](#input\_cidr\_pubsubnet) | list of public cidrs | `list(any)` | <pre>[<br>  "10.0.0.0/24",<br>  "10.0.2.0/24"<br>]</pre> | no |
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | n/a | `string` | `"kojitechs"` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | create vpc | `bool` | `true` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | n/a | `string` | `"kojitechs.com"` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | http from everywhere | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | https from everywhere | `number` | `8080` | no |
| <a name="input_register_dns"></a> [register\_dns](#input\_register\_dns) | n/a | `string` | `"kojitechs.com"` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | n/a | `map(string)` | <pre>{<br>  "default": "*.kojitechs.com",<br>  "sbx": "*.kelderanyi.com"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet"></a> [database\_subnet](#output\_database\_subnet) | for loop |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | n/a |
| <a name="output_private_subnet"></a> [private\_subnet](#output\_private\_subnet) | Deprecated |
| <a name="output_pub_subnet"></a> [pub\_subnet](#output\_pub\_subnet) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Authors

## Usage 
ec2 instance private keypair in stored in ssm parameter store to download the key form ssm parameter store 

```bash
aws ssm get-parameter --name "jenkins-agent-bootstrap-ssh-key" --output text --query Parameter.Value >> "./jenkins_ssh_file"
ssh -i "jenkins_ssh_file" ec2-user@public_ip
```

Module is maintained by 
