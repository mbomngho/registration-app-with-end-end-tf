
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws region"
}


variable "cidr_pubsubnet" {
  type        = list(any)
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  description = "list of public cidrs"
}

variable "cidr_privsubnet" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  description = "list of private cidrs"
}

variable "environment" {
  description = "Environment this template would be deployed to"
  type        = map(string)
  default     = {}
}


variable "cidr_database" {
  type        = list(any)
  default     = ["10.0.5.0/24", "10.0.7.0/24"]
  description = "list of database cidrs"
}


variable "create_vpc" {
  type        = bool
  default     = true
  description = "create vpc"
}

variable "component_name" {
  default = "kojitechs"
}

variable "http_port" {
  description = "http from everywhere"
  type        = number
  default     = 80
}


variable "https_port" {
  description = "https from everywhere"
  type        = number
  default     = 8080
}

variable "dns_name" {
  type    = string
  default = ""
}

variable "subject_alternative_names" {
  type    = map(string)
  default = {}
}
