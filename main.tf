

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
#EKS module
module "eks" {
  depends_on                 = [module.vpc]
  source                     = "./modules/eks"
  eks_cluster_name           = "linheks"
  eks_cluser_enginee_version = "1.27"
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_id
  instance_types             = ["t2.large", "t3.large", "t2.medium", "t3.medium"]
  ami_id                     = "ami-0694f331bbf33fefa"
  tags                       = var.tags
}
resource "random_integer" "subnet" {
  min = 0
  max = length(module.vpc.public_subnet_id) > 0 ? length(module.vpc.public_subnet_id) - 1 : 0
}

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

  public_subnet_id = module.vpc.public_subnet_id[random_integer.subnet.resu
  lt]
  bastion_monitoring          = each.value.bastion_monitoring
  default_tags = merge(
    var.tags,
    each.value.ext-tags,{
      "ext-env" : terraform.workspace
    }
  )

}
