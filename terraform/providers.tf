terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-terraform-backend"
    region     = "ru-central1"
    key        = "terraform/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }  
}

provider "yandex" {
  zone = "ru-central1-a"
}
