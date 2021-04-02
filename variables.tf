variable "resgrp" {
  type    = string
  default = "k8s-install"
}

variable "region" {
  type    = string
  default = "eastus"
}

variable "resgrptag" {
  type    = string
  default = "k8sInstall"
}

variable "vnet" {
  type    = string
  default = "k8sInstallVnet"
}

variable "cidr" {
  type    = list
  default = ["10.0.1.0/24"]
}

variable "subnetname" {
  type    = string
  default = "K8sInstallSubnet"
}

variable "subnet" {
  type    = list
  default = ["10.0.1.0/25"]
}

variable "publicip" {
  type    = string
  default = "K8sPublicIP"
}

variable "sgname" {
  type    = string
  default = "K8sSG"
}

variable "netIntName" {
  type    = string
  default = "K8sNetInt"
}

variable "ipName" {
  type    = string
  default = "K8sIP"
}

variable "vmName" {
  type    = string
  default = "K8sInstallVM"
}

variable "osDiskName" {
  type    = string
  default = "K8sInstallOSDisk"
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






