terraform {

  required_version = "~>1.3"

  //This is DigitalOcean cloud provider

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}


provider "digitalocean" {

  token = var.do_token # This is the DigitalOcean API token.


  # Alternatively, this can also be specified using environment variables ordered by precedence:
  # DIGITALOCEAN_TOKEN, 
  # DIGITALOCEAN_ACCESS_TOKEN
}