###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_cidr_b" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_name_b" {
  type        = string
  default     = "develop-b"
  description = "VPC network & subnet name"
}

###ssh vars

/*
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
  description = "ssh-keygen -t ed25519"
}
*/

variable "vm_resources" {
  type        = map(map(number))
  description = "Resources map for VMs"
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "vm_metadata" {
  type        = map(string)
  description = "Metadata map for VMs"
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
  }
}