provider "aws" {
  shared_credentials_file = "C:/Users/111/.aws/credentials"
  alias   = "source"
  profile = "source"
  region = "ap-northeast-1"
}

provider "docker" {

}