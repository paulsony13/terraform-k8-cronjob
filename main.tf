resource "kubernetes_cron_job_v1" "cronjob" {
  for_each = var.cronjobs ? {
    for idx, cronjob in var.cronjobs : idx => cronjob
  } : {}
  metadata {
    name      = each.value.cronjob_name
    namespace = var.namespace
    labels    = merge(var.default_labels, each.value.labels)
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = each.value.cronjob_schedule
    timezone                      = each.value.cronjob_timezone
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    suspend                       = !each.value.enabled

    job_template {
      metadata {
        labels = merge(var.default_labels, each.value.labels)
      }
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10

        template {
          metadata {
            labels = merge(var.default_labels, each.value.labels)
          }
          spec {
            restart_policy       = "OnFailure"
            service_account_name = each.value.service_account_name

            dynamic "node_selector" {
              for_each = each.value.node_selector != null ? [each.value.node_selector] : []
              content {
                match_labels = node_selector.value
              }
            }
            dynamic "toleration" {
              for_each = each.value.tolerations != null ? each.value.tolerations : []
              content {
                key      = toleration.value.key
                value    = toleration.value.value
                effect   = toleration.value.effect
                operator = toleration.value.operator
              }
            }
            container {
              name              = each.value.cronjob_name
              image             = each.value.cronjob_image
              image_pull_policy = "IfNotPresent"
              command           = each.value.cronjob_command
              dynamic "env" {
                for_each = each.value.env_vars != null ? each.value.env_vars : []
                content {
                  name  = env.value.name
                  value = env.value.value
                }
              }
              dynamic "resources" {
                for_each = each.value.resources != null ? [1] : []
                content {
                  limits   = each.value.resources.limits
                  requests = each.value.resources.requests
                }
              }
            }
          }
        }
      }
    }
  }
}
