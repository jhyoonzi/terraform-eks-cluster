
provider "aws" {
  profile = var.profile
  region  = var.main-region
  alias   = "ap-northeast-2"
}

