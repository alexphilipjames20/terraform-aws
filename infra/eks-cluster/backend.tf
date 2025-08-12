terraform {
  backend "s3" {
    bucket = "sherlock-terraform-eks-state"
    key = "eks.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}