variable "vm_name" {
  type    = string
  default = "ark-palworld-vm"
}

variable "cpus" {
  type    = number
  default = 4
}

variable "memory" {
  type    = number
  default = 8192
}

variable "disk_size" {
  type    = number
  default = 50  # Go
}
