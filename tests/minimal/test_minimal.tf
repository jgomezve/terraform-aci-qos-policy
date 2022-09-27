terraform {
  required_version = ">= 1.0.0"
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."
  name   = "MIN_POL"
  tenant = "TEN1"
}

data "aci_rest_managed" "qosCustomPol" {
  dn = "uni/tn-TEN1/qoscustom-MIN_POL"

  depends_on = [module.main]
}

resource "test_assertions" "qosCustomPol" {
  component = "qosCustomPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.qosCustomPol.content.name
    want        = "MIN_POL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.qosCustomPol.content.descr
    want        = ""
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest_managed.qosCustomPol.content.nameAlias
    want        = ""
  }
}
