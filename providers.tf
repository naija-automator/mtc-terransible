terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    region = "eu-west-2"
  #  profile = "default"
  #  shared_credentials_file="/home/ktimmons/.aws/credentials"
}
