provider "google" {
    #change credentials to where the json key is stored
    credentials = file("terraform-key.json")
    #change project to your project id in GCP
    project = "PROJECT_ID"
    #change region to preferred GCP region
    region = "us-west1"
    #change this to a GCP zone in the region
    zone = "us-west1-a"
}

resource "google_compute_network" "vpc_network" {
    #change name to preferred vpc name
    name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
    #change name to preferred vm name
    name = "terraform-instance"
    #change name to preferred vm machine type
    machine_type = "f1-micro"

    boot_disk {
        initialize_params {
            #change name to preferred vm image
            image = "debian-cloud/debian-9"
        }
    }

    network_interface {
        network = google_compute_network.vpc_network.name
        access_config {
        }
    }
}

resource "google_compute_address" "vm_static_ip" {
    name = "terraform-static-ip"
}

terraform {
    backend "gcs" {
        #change bucket to GCP bucket that will store terraform state file
        bucket = "gcp-terraform-lab"
        #change prefix to folder inside bucket
        prefix = "terraform1"
        #change credentials to where the json key is stored
        credentials = "terraform-key.json"
    }
}