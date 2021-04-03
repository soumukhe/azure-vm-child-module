variable "resgrp" {
  type    = string
  default = "aciBootcamp-install"
}

variable "region" {
  type    = string
  default = "eastus"
}

variable "resgrptag" {
  type    = string
  default = "aciBootcampInstall"
}

variable "vnet" {
  type    = string
  default = "aciBootcampInstallVnet"
}

variable "cidr" {
  type    = list
  default = ["10.0.1.0/24"]
}

variable "subnetname" {
  type    = string
  default = "aciBootcampInstallSubnet"
}

variable "subnet" {
  type    = list
  default = ["10.0.1.0/25"]
}

variable "publicip" {
  type    = string
  default = "aciBootcampPublicIP"
}

variable "sgname" {
  type    = string
  default = "aciBootcampSG"
}

variable "netIntName" {
  type    = string
  default = "aciBootcampNetInt"
}

variable "ipName" {
  type    = string
  default = "aciBootcampIP"
}

variable "vmName" {
  type    = string
  default = "aciBootcampInstallVM"
}

variable "osDiskName" {
  type    = string
  default = "aciBootcampInstallOSDisk"
}

variable "imagePublisher" {
  type    = string
  default = "Canonical"
}

variable "image" {
  type    = string
  default = "UbuntuServer"
}

variable "imageSku" {
  type    = string
  default = "18.04-LTS"
}

variable "adminUser" {
  type    = string
  default = "azureuser"
}

variable "privKey" {
  type = string
  default = "sshPrivKeyName"
}






