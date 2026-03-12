terraform {
  backend "s3" {
    bucket  = "princes-tf-state-bucket-9988"
    key     = "infra.tfstate"
    region  = "ap-south-1"
    profile = "default"
    # dynamodb_table = "vegeta-terraform-remote-state-table"
  }
}
