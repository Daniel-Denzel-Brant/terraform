provider "aws" {
  //shared_config_files = "C:/Users/111/.aws/config"
  shared_credentials_file = "C:/Users/111/.aws/credentials"
  alias   = "source"
  profile = "source"
  region  = "ap-northeast-1"
}

provider "aws" {
  //shared_config_files = ["C:/Users/111/.aws/config"]
  shared_credentials_file = "C:/Users/111/.aws/credentials"
  alias   = "destination"
  profile = "destination"
  region  = "ap-northeast-1"
}

data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_iam_policy" "ec2" {
  provider = aws.destination
  name     = "AmazonEC2FullAccess"
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws.destination
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "assume_role" {
  provider            = aws.destination
  name                = "assume_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [data.aws_iam_policy.ec2.arn]
  tags                = {}
}

