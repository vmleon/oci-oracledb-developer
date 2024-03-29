terraform {
  required_providers {
    oci = {
      source                = "oracle/oci"
      version               = "~> 5.23"
      configuration_aliases = [oci.home_region]
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
      # https://registry.terraform.io/providers/hashicorp/random/
    }
  }
}
