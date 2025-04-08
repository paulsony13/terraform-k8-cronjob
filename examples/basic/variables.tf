variable "cronjobs" {
  description = "List of CronJobs to deploy"
  type = list(object({
    cronjob_name           = string
    cronjob_image          = string
    cronjob_command        = list(string)
    cronjob_schedule       = string
    cronjob_timezone       = string
    enabled                = bool
    env_vars               = optional(list(object({
      name  = string
      value = string
    })), [])
    labels                 = optional(map(string), {})
    node_selector          = optional(map(string))
    tolerations            = optional(list(object({
      key      = string
      value    = string
      effect   = string
      operator = string
    })))
    resources              = optional(object({
      requests = map(string)
      limits   = map(string)
    }))
    service_account_name   = optional(string, "default")
  }))
}

variable "enable_cronjobs" {
  default = true
}

variable "namespace" {
  default = "default"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "default_labels" {
  type    = map(string)
  default = {
    "app.kubernetes.io/managed-by" = "terraform"
  }
}