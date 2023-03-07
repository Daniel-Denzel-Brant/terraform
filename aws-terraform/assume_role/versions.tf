terraform {
  //cloud {
    //organization = "DanielDB"

    //workspaces {
      //name = "CLI-Driven-Workflow"
    //}
  //}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2 "
    }
  }

  required_version = ">= 0.15"
}
