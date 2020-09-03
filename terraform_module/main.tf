provider "google" {
  #change credentials to where the json key is stored
  credentials = file("../terraform-key.json")
  #change project to your project id in GCP
  project = "gcp-terraform-288221"
  #change region to preferred GCP region
  region = "us-west1"
  #change this to a GCP zone in the region
  zone = "us-west1-a"
}

module "vpc" {
    source          = "terraform-google-modules/network/google//modules/subnets"
    version         = "~> 2.0.0"
    
    network_name    = "terraform-vpc-network"
    project_id      = var.project

    subnets = [
        {
            subnet_name     = "subnet-01"
            subnet_ip       = "10.1.0.0/16"
            subnet_region   = var.region
        },
        #private subnet
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.1.0.0/16"
            subnet_region         = var.region
            google_private_access = true
        }
    ]

    secondary_ranges = {
        subnet-01           = []
    }
}

module "network_routes" {
    source          = "terraform-google-modules/network/google//modules/routes"
    version         = "2.1.1"
    network_name    = "terraform-vpc-network"
    project_id      = var.project

    routes = [ 
        {
            name                = "egress-internet"
            description         = "route through IGW to access internet"
            destination_range   = "0.0.0.0/0"
            tags                = "egress-inet"
            next_hop_internet   = "true"
        }   
    ]
}

module "fabric-net-firewall" {
    source                      = "terraform-google-modules/network/google//modules/fabric-net-firewall"
    project_id                  = var.project 
    network                     = "terraform-vpc-network"
    internal_ranges_enabled     = true 
    internal_ranges             = var.cidr
}