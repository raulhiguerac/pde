variable "project" {
  description = "name of the gcp project"
  type        = string
}

variable "project_region" {
  description = "region of the resources in the project"
  type        = string
}

variable "project_region_zone" {
  description = "zone of the region of the resources in the project"
  type        = string
}

variable "vpc_name" {
  description = "name of the vpc network"
  type        = string
}

variable "vpc_subnetworks" {
  description = "subnetworks of vpc"
  type        = bool
  default     = false
}

variable "vpc_routing_mode" {
  description = "routing mode of the vpc"
  type        = string
  default     = "GLOBAL"
}

variable "vpc_subnet_name" {
  description = "name of the vpc subnet"
  type        = string
}

variable "vpc_cidr_range" {
  description = "cidr range for the vpc"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_secondary_ip_ranges" {
  description = "ip ranges for services and pods"
  type = map(object({
    secondary_range = object({
      range_name    = string
      ip_cidr_range = string
    })
  }))
  default = {
    gke-pods = {
      secondary_range = {
        range_name    = "gke-pods"
        ip_cidr_range = "192.168.10.0/24"
      }
    }
    gke-services = {
      secondary_range = {
        range_name    = "gke-services"
        ip_cidr_range = "192.170.10.0/24"
      }
    }
  }
}

variable "gke_name" {
  description = "gke cluster name"
  type        = string
}

variable "gke_pods" {
  description = "max pods per node in gke cluster"
  type = number
  default = 55 // max allowed pods per node is 110
}

variable "name_node_pool" {
  description = "name of the node pool of gke cluster"
  type = string
  default = "airflow-nodes-pool"
}

variable "number_nodes" {
  description = "number of nodes in the gke cluster" // set this number for your requirements
  type = number
  default = 2
}

variable "machine_type" {
  description = "type of machine used in a node"
  type = string
  default = "n1-standard-2" // this machine have 7.5 GB RAM and 2 VCPU
}

variable "disk_size" {
  description = "size of the disk attached to each node"
  type = number
  default = 40
}