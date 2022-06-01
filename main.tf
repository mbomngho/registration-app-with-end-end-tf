
locals {
  mandatory_tag = {
    line_of_business        = "hospital"
    ado                     = "max"
    tier                    = "WEB"
    operational_environment = upper(terraform.workspace)
    tech_poc_primary        = "udu.udu25@gmail.com"
    tech_poc_secondary      = "udu.udu25@gmail.com"
    application             = "http"
    builder                 = "udu.udu25@gmail.com"
    application_owner       = "kojitechs.com"
    vpc                     = "WEB"
    cell_name               = "WEB"
    component_name          = var.component_name
  }

  vpc_id        = try(aws_vpc.Kojitechs[0].id, "")
  create_vpc    = var.create_vpc
  azs           = data.aws_availability_zones.available.names
  pub_subnet_id = { for id, subnets in aws_subnet.public_subnet : id => subnets.id }

  sunbet = {
    subnet_1 = {
      cidr_blocks = var.cidr_pubsubnet[0]
      az          = local.azs[0]
    }
    subnet_2 = {
      cidr_blocks = var.cidr_pubsubnet[1]
      az          = local.azs[1]
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

#  To access a resource id of a single instance like aws_vpc.Kojitechs.id
# To access a resource id of a count objeect is df aws_vpc.Kojitechs[0].id
resource "aws_vpc" "Kojitechs" {
  count = local.create_vpc ? 1 : 0

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "kojitechs"
  }
}

resource "aws_internet_gateway" "igw" {
  count = local.create_vpc ? 1 : 0

  vpc_id = local.vpc_id

  tags = {
    "Name" = "kojitechs_igw"
  }
}

# creating public subnet
resource "aws_subnet" "public_subnet" {
  #count = local.create_vpc ? length(var.cidr_pubsubnet) : 0
  for_each = local.create_vpc ? local.sunbet : {}

  vpc_id                  = local.vpc_id
  cidr_block              = each.value.cidr_blocks
  map_public_ip_on_launch = true
  availability_zone       = each.value.az

  tags = {
    "Name" = each.key
  }
}


resource "aws_subnet" "priv_sub" {
  count = local.create_vpc ? length(var.cidr_privsubnet) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.cidr_privsubnet[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    "Name" = "priva-sub-${local.azs[count.index]}"
  }

}

# creating dababase subnet
resource "aws_subnet" "database_sub" {
  count = local.create_vpc ? length(var.cidr_database) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.cidr_database[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    "Name" = "database-sub-${local.azs[count.index]}"
  }
}

# creating routes
resource "aws_route_table" "route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}


resource "aws_route_table_association" "route_tables_ass" {
  for_each = toset(keys(aws_subnet.public_subnet))

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.route_table.id
}

# creating the default route table
resource "aws_default_route_table" "default_route" {
  count = local.create_vpc ? 1 : 0

  default_route_table_id = try(aws_vpc.Kojitechs[0].default_route_table_id, "")

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1[0].id
  }
}

resource "aws_eip" "eip" {
  count      = local.create_vpc ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

}

# creating nat gateway
resource "aws_nat_gateway" "ngw_1" {
  count = local.create_vpc ? 1 : 0

  allocation_id = aws_eip.eip[0].id
  subnet_id     = [for id in aws_subnet.public_subnet : id.id][0]

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "gw_NAT"
  }
}
