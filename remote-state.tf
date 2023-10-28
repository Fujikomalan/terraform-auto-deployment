terraform {
  backend "s3" {
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
