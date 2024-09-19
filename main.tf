

locals {
  azs = length(data.aws_availability_zones.available.names)
  
}
#NetWork Module
module "vpc" {
  source = "./modules/network"
   azs      = local.azs
   cidrvpc  = var.cidrvpc
   azname   = data.aws_availability_zones.available.names
   vpc_name = var.vpc_name
   tags     = merge(var.tags ,{
    "ext-env" : terraform.workspace
   })
   
}
# EC Module
resource "random_integer" "subnet" {
  min = 0
  max = length(module.vpc.public_subnet_id) > 0 ? length(module.vpc.public_subnet_id) - 1 : 0
}

# resource "random_integer" "subnet_index" {
#   min = 0
#   max = length(module.vpc.public_subnet_id) - 1
#   count = length(module.vpc.public_subnet_id) > 0 ? 1 : 0
# }
# output "public_subnet_id" {
#   value = aws_subnet.public[*].id
# }
module "ec2" {
  depends_on = [
    module.vpc
  ]
  source                      = "./modules/ec2"
  for_each                    = var.bastion_definition
  vpc_id                      = module.vpc.vpc_id
  bastion_instance_class      = each.value.bastion_instance_class
  bastion_name                = each.value.bastion_name
  bastion_public_key          = each.value.bastion_public_key
  trusted_ips                 = toset(each.value.trusted_ips)
  user_data_base64            = each.value.user_data_base64
  bastion_ami                 = each.value.bastion_ami
  associate_public_ip_address = each.value.associate_public_ip_address
  #  public_subnet_id            = module.vpc.public_subnet_id[0]
  #public_subnet_id = module.vpc.public_subnet_id[random_integer.subnet.result]

  public_subnet_id = module.vpc.public_subnet_id[random_integer.subnet.result]
  bastion_monitoring          = each.value.bastion_monitoring
  default_tags = merge(
    var.tags,
    each.value.ext-tags,{
      "ext-env" : terraform.workspace
    }
  )

}



# resource "aws_vpc" "linhct-vpc" {
#   cidr_block = var.cidrvpc
#   tags       = var.tags
# }

# Public subnet
# resource "aws_subnet" "public" {
#   count               = var.az_count
#   cidr_block          = cidrsubnet(aws_vpc.linhct-vpc.cidr_block, 8, count.index)
#   availability_zone   = data.aws_availability_zones.available.names[count.index]
#   vpc_id              = aws_vpc.linhct-vpc.id
#   tags = merge({
#     Name = "${var.vpc_name}-public-subnet"
#   }, var.tags)
# }
# #create internet gateway
# resource "aws_internet_gateway" "main-igw" {
#   vpc_id = aws_vpc.linhct-vpc.id
#   tags = merge({
#     Name = "${var.vpc_name}-igw"
#   },
#   var.tags)
# }
# resource "aws_route" "main-route" {
#   route_table_id = aws_vpc.linhct-vpc.main_route_table_id
#   destination_cidr_block =  "0.0.0.0/0"
#   gateway_id =  aws_internet_gateway.main-igw.id
# }
# #asosicate public subet to main route table
# resource "aws_route_table_association" "public-subnet" {
#   count = var.az_count
#   subnet_id = element(aws_subnet.public.*.id,count.index)
#   route_table_id = aws_vpc.linhct-vpc.main_route_table_id
# }
# #Private subnet
# resource "aws_subnet" "private" {
#   count               = var.az_count
#   cidr_block          = cidrsubnet(aws_vpc.linhct-vpc.cidr_block, 8, count.index + var.az_count)
#   availability_zone   = data.aws_availability_zones.available.names[count.index]
#   vpc_id              = aws_vpc.linhct-vpc.id
#   tags = merge({
#     Name = "${var.vpc_name}-private-subnet"
#   }, var.tags)
# }
# resource "aws_eip" "ngweip" {
#   count = var.az_count
#   tags = merge({
#     ext-name = "${var.vpc_name}-ngw-eip-${count.index}"
#   },var.tags)
# }
# #create natgetway
# resource "aws_nat_gateway" "ngw" {
#   count = var.az_count
#   subnet_id = element(aws_subnet.private.*.id ,count.index)
#   allocation_id = element(aws_eip.ngweip.*.id ,count.index)
#   tags = merge({
#     ext-name = "${var.vpc_name}-ngw-eip-${count.index}"
#   },var.tags)
# }
# resource "aws_route_table" "private_rtb" {
#     count = var.az_count
#     vpc_id = aws_vpc.linhct-vpc.id
#       # duong di cua route_table cho private subnet 
#     route {
#       cidr_block = "0.0.0.0/0"
#       nat_gateway_id = element(aws_nat_gateway.ngw.*.id ,count.index)

#     }
#     tags = merge({
#       ext-name = "${var.vpc_name}-private-rtb-${count.index}"
#     },var.tags)
# }
#  #asosicate the private subnets to private rtb
#  resource "aws_route_table_association" "private-subnet-rtb" {
#    count = var.az_count
#    subnet_id = element(aws_subnet.private.*.id,count.index)
#    route_table_id = element(aws_route_table.private_rtb.*.id ,count.index)
#  }
