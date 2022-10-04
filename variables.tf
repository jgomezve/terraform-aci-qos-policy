variable "name" {
  description = "QoS Policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "QoS Policy alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "QoS Policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "tenant" {
  description = "QoS Custom Policy's Tenant name"
  type        = string
}

variable "dscp_priority_maps" {
  description = "QoS Policy DSCP Priority Maps. Allowed values `dscp_from`, `dscp_to` and `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` or `CS7`. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. Allowed values `cos_target`: 0-7"
  type = list(object({
    dscp_from   = string
    dscp_to     = string
    priority    = optional(string, "level3")
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.dscp_from == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], pm.dscp_from), false) || try(pm.cos_target >= 0 && pm.cos_target <= 63, false)
    ])
    error_message = "`dscp_from`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` or `CS7`."
  }
  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.dscp_to == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], pm.dscp_to), false) || try(pm.cos_target >= 0 && pm.cos_target <= 63, false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` or `CS7`."
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.priority == null || try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6", ], pm.priority), false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`"
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.dscp_target == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], pm.dscp_target), false) || try(pm.cos_target >= 0 && pm.cos_target <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` or `CS7`."
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.cos_target == null || try(pm.cos_target >= 0 && pm.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Minimum value: `0`. Maximum value: `7`."
  }
}

variable "dot1p_classifiers" {
  description = "QoS Policy DSCP Priority Maps. Allowed values `dot1p_from`, `dot1p_to` and `cos_target`: 0-7. Allowed values `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` or `CS7`. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`."
  type = list(object({
    dot1p_from  = string
    dot1p_to    = string
    priority    = optional(string, "level3")
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.dot1p_from == null || try(dot1p.dot1p_from >= 0 && dot1p.dot1p_from <= 7, false) || dot1p.dot1p_from == "unspecified"
    ])
    error_message = "`dot1p_from`: Minimum value: `0`. Maximum value: `7`."
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.dot1p_to == null || try(dot1p.dot1p_to >= 0 && dot1p.dot1p_to <= 7, false) || dot1p.dot1p_to == "unspecified"
    ])
    error_message = "`dot1p_to`: Minimum value: `0`. Maximum value: `7`."
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.priority == null || try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6", ], dot1p.priority), false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`"
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.dscp_target == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], dot1p.dscp_target), false) || try(dot1p.dscp_target >= 0 && dot1p.dscp_target <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` or `CS7`."
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.cos_target == null || try(dot1p.cos_target >= 0 && dot1p.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Minimum value: `0`. Maximum value: `7`."
  }
}