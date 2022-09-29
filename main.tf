resource "aci_rest_managed" "qosCustomPol" {
  dn         = "uni/tn-${var.tenant}/qoscustom-${var.name}"
  class_name = "qosCustomPol"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "qosDscpClass" {
  for_each   = { for pm in var.dscp_priority_maps : "${pm.dscp_from}-${pm.dscp_to}" => pm }
  dn         = "${aci_rest_managed.qosCustomPol.id}/dcsp-${each.value.dscp_from}-${each.value.dscp_to}"
  class_name = "qosDscpClass"
  content = {
    from      = each.value.dscp_from
    prio      = each.value.priority
    target    = each.value.dscp_target
    targetCos = each.value.cos_target
    to        = each.value.dscp_to
  }
}

resource "aci_rest_managed" "qosDot1PClass" {
  for_each   = { for dot1p in var.dot1p_classifiers : "${dot1p.dot1p_from}-${dot1p.dot1p_to}" => dot1p }
  dn         = "${aci_rest_managed.qosCustomPol.id}/dot1P-${each.value.dot1p_from}-${each.value.dot1p_to}"
  class_name = "qosDot1PClass"
  content = {
    from      = each.value.dot1p_from
    prio      = each.value.priority
    target    = each.value.dscp_target
    targetCos = each.value.cos_target
    to        = each.value.dot1p_to
  }
}