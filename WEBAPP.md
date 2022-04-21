# IAC-Terraform-Repo

## Using Terraform to set up baston connection 



###  Download the key from parameter store u can use thise command 

```bash
aws ssm get-parameter --name "kojitechs-ssm-kp" --output text --query  Parameter.Value > "parafile"
```

## Connect
## To connect to our app 

```hcl
Username: admin101
Password: password101
```
### To run this code you should use 

```hcl
terraform init 
terraform plan 
terraform apply --auto-approve 
```
## Connect to our mysql
```bash 
mysql -h dbendpoint -u username -p dbpasswd
mysql> show schemas;
mysql> use webappdb;
mysql> show tables;
mysql> select * from user;
```
