###VM vars

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}
/*
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}
*/

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}
/*
variable "vm_web_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_web_memory" {
  type        = string
  default     = "1"
  description = "VM memory GB"
}

variable "vm_web_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core"
}
*/
variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}
/*
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "instance name"
}
*/
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}
/*
variable "vm_db_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_db_memory" {
  type        = string
  default     = "2"
  description = "VM memory GB"
}

variable "vm_db_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core"
}
*/