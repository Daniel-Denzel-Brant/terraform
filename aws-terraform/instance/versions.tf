terraform {
  //cloud {
    //organization = "DanielDB"

    //workspaces {
      //name = "CLI-Driven-Workflow"
    //}
  //}
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2"
    }
  }

  required_version = ">= 0.15"
}

