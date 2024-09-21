locals {
  region = data.aws_region.current.name
  allocation_id = data.aws_caller_identity.current.account_id
}