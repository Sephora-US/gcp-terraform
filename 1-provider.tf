provider google {
  project="sep-poc-aa-hackathon-prj"
  region="us-central1"
}

terraform {
 backend "gcs" {
  bucket = "aa-hackathon-tf-state"
  prefix = "terraform/state"
 }
 required_providers {
  google = {
    source = "hashicorp/google"
    version = "~> 5.4.0"
  }
 }
}
