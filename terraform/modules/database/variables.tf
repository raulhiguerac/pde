variable "project_region" {
  description = "region of the resources in the project"
  type        = string
}

variable "name_private_ip_adress" {
  description = "name of the private ip adress to pass to gke cluster"
  type = string
  default = "private-ip-address"
}

variable "purpose_private_ip_adress" {
  description = "purpose of the ip adress"
  type = string  
  default = "VPC_PEERING"
}

variable "adress_type_private_ip_adress" {
  description = "adress type of the private ip adress"
  type = string
  default = "INTERNAL"
}

variable "prefix_private_ip_adress" {
  description = "The prefix length of the IP range"
  type = number
  default = 16
}

variable "network_private_ip_adress" {
  description = "vpc network to peer the private ip adress"
}

variable "network_vpc_connection" {
  description = "vpc network to connect from db"
}

variable "db_instance_name" {
  description = "name of the sql instance"
  type        = string
}

variable "db_version" {
  description = "version of the sql db"
  type        = string
}

variable "db_tier" {
  description = "type of the db to use"
  type        = string
}

variable "db_edition" {
  description = "edition type of the db"
  type        = string
}

variable "db_disk_size" {
  description = "db disk size in GB"
  type        = string
}

variable "instance_private_network" {
  description = "vpc network to connect from db"
}

variable "database_name" {
  description = "name of the airflow database"
  type = string  
  default = "airflow_db"
}

variable "airflow_secrets" {
  description = "variable that contains all the secrets (user_db,password)"
  type = map(any)
}