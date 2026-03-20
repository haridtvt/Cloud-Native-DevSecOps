variable "region" {
    type = string
    description = "The AWS region to deploy resources"
}
variable "access_key" {
    type = string
}
variable "secret_key" {
    type = string
}
variable "public_key" {}
variable "ami_id" {}