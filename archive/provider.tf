terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"  #--> Specify the version that you have downloaded from internet 
    }
  }
}

provider "aws" {
    region = "eu-west-2"
}