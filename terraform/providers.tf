terraform {

  backend "s3" {
    bucket       = "flaskapp-tfstate-1"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # required_version = ">= 1.0.0" #tflint

}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment      = "dev"
      Project          = "flaskapp"
      CreatedBy        = "Terraform"
      Version          = "1.0.0"
      TerraformVersion = "v1.15.5"
      Owner            = "gbarrera"
    }
  }
}