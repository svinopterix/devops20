terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "local" {
  }  
}

provider "yandex" {
  token = "y0_AgAAAAARXFVvAATuwQAAAADOUEADTpB7egonRDCX1012P8C6ZIkONww"
  zone = "ru-central1-a"
  folder_id = "b1g120ok8eob761pks4v"
}
