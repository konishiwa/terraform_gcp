variable "project" {
  #change default to your project id
  default = "gcp-terraform-288221"
}
variable "region" {
  default = "us-west1"
}
variable "zone" {
  default = "us-west1-a"
}
variable "cidr" {
  default = ["10.0.0.0/16"]
}