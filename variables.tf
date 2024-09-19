# variable "vpc_name" {
#   default = "main"
# }
# variable "cidrvpc" {
#   default = "10.0.0.0/16"
# }
# variable "tags" {
#   default = {
#     Name ="vpc-linhct1"
#     Owner ="linhct"
#   }
# }
# variable "create_s3_bucket" {
#     default = true
# }
# variable "vm-config" {
#   default = {
#     vm1 = {
#       instance_type = "t2.small",
#       tags = {
#         "ext-name" = "vm2"
#         "funct"    = "purpose test"
#       }
#     },
#     vm2 = {
#       instance_type = "t2.medium",
#       tags          = {}
#     }
#   }

# }
# variable "bastion_definition" {
#   description = "The definition of bastion instance"
#   # type = map(object({
#   #   bastion_name                = string
#   #   bastion_public_key          = string
#   #   bastion_ami                 = string
#   #   bastion_instance_class      = string
#   #   trusted_ips                 = set(string)
#   #   user_data_base64            = string
#   #   associate_public_ip_address = bool
#   #   bastion_monitoring          = bool
#   #   ext-tags  = map(object({}))
#   # }))
#   default = {
    # "bastion" = {
      # associate_public_ip_address = false
      # bastion_ami                 = "ami-0694f331bbf33fefa"
      # bastion_instance_class      = "t3.medium"
      # bastion_monitoring          = true
      # bastion_name                = "bastion"
      # bastion_public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZDPjo4WOjAHc73bkiQOxtZIpf6c3GwALzRH1g77lGbrXo1rFz164St7V853V1gIntDVk26LucQaUUcvxpAlbRgIxZ3fO27SjXiL9GuAtWgVi5APl5leiqfWOy2eMhT6sbPfrWyzQj5uCB7bCNZBBxMvd5dq+Dh4chkFAyIesHg1anQR7OdLqWxXBuO6hFBMmLKz9L35S4FFaCRatI58RiskgPpsW0ZrQxM6kL4rMqm+6w4aE8eew1xmhNTun8nwwRt7JSmAcYB8EDqPurhZ+7o1Vq9R1HcdoQ38RgHgNRYHgyE9v83PRkiM2ph7HnG45DLJFJmNNZX/v8/N87mnPLTnLR7hVultfF8dgdNCpxgb/d+e/e+LzxCG2Qy4OMQlLxwTgL57Xyz9Odu4qmBNnSDrjOCGqbS/UBIvt+4MJkt3geMJW+RKQy2Ew/czbmJoF8GAo5k5i+B67D2EmCprC2Go7naajOhVrhupJ1FEFy7uASqSFu6k+gPVj0ZS9+Gq8pzc9FvBLbxoKi1VUNMdBm+qqhFbKjSUQmtxSUfystbNX/fxp/lzRpyUBNlHAx8srVAtQDS4BFxvbtf619H4zHAXU9OS/6XeY1x5ZjpV4Uk00P/9eGh994gkU2OPDVlSdZJpElBofO2aHPgdtY9Eyts7vs5BIdJJzSzea3CS7NSw== linhb@gamil.com"
      # trusted_ips                 = ["116.108.118.61/32"]
      # user_data_base64            = null
      # ext-tags = {
      #   "fucnt" = "demo-tf-ec2"
      # }
#     }
#   }
# }
variable "vpc_name" {
  default = "main"
}
variable "cidrvpc" {
  default = "10.0.0.0/16"
}

variable "tags" {
  default = {
    Name ="vpc-linhct1"
    Owner ="linhct"
  }
}

variable "create_s3_bucket" {
  default = true
}

variable "vm-config" {
  default = {}
}


variable "bastion_definition" {
  description = "The definition of bastion instance"
  default     = {}
}
