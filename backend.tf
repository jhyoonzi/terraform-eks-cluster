provider "aws" {
  region  = "ap-northeast-2"
  profile = "default"
}

terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "ap-northeast-2"
    profile = "default"
    key     = "eks_tfstate_file"
    bucket  = "eks_tfstate_file"
  }
}

