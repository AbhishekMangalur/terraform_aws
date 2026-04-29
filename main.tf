module "networking" {
  source = "./networking"
}

module "ssh_key" {
  source = "./ssh-key"
}

module "ec2" {
  source = "./ec2"

  vpc_id            = module.networking.vpc_id
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  key_name          = "terraform-key"
}