provider "aws" {
  profile = "terra"
  region  = "us-east-1"

}

module "prod" {
    source = "../logic"

vpc_cidr = "10.0.0.0/16"
public_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
private_cidr = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"] #---- repeating cycle
#tag = "demo mode1"

tag = {
  purpose = "my_vpc"
}

env = "prod"
owner = "local_user"

}