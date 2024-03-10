variable "region" {
  type    = string
  default = "us-central1"
}

variable "db_location_preference" {
  type    = string
  default = "us-central1-a"
}

variable "db_instance" {
  type = string
}


variable "db_machine_type" {
  type    = string
  default = "db-n1-standard-2"
}

variable "db_version" {
  type    = string
  default = "POSTGRES_12"
}

variable "db_default_disk_size" {
  type    = string
  default = "100"
}

variable "max_connections" {
  description = "max db connection size"
}

variable "db_availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "db_list" {
  type        = list
  description = "list of databases that should be create in an instance"
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}


variable "vpc_network" {
  type        = string
  description = "vpc network where database will be deployed"
}

variable "network_id" {
  type        = string
  description = "network id"
}

variable "deletion_protection" {
  type        = bool
}
