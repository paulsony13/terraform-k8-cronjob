# k8-cronjob

A reusable and scalable Terraform module to deploy Kubernetes CronJobs on AWS EKS using the `kubernetes_cron_job_v1` resource. The module supports multiple cronjobs with full flexibility in schedule, image, resources, env vars, tolerations, and more.

---

## 📦 Resources Created

- `kubernetes_cron_job_v1`: One per cronjob object in `var.cronjobs`.

---

## ✅ Usage

```hcl
module "app_cronjobs" {
  source    = "paulsony13/terraform-k8-cronjob"
  namespace = "namespace"
  eks_cluster_name = "my-cluster"
  aws_region       = "us-east-1"
  default_labels = {
    "team"    = "devops"
    "managed" = "terraform"
  }
  cronjobs = [
    {
      enabled          = true
      cronjob_name     = "db-backup"
      cronjob_image    = "postgres:15"
      cronjob_command  = ["sh", "-c", "pg_dump -h db -U user dbname > /backup.sql"]
      cronjob_schedule = "0 2 * * *"
      cronjob_timezone = "UTC"
    }
  ]
  // Add in more <configs> as needed
}
```

## 🛠️ Inputs
| Name               | Type           | Description                                        |
|--------------------|----------------|----------------------------------------------------|
| `namespace`        | `string`       | The namespace in which to deploy the CronJobs      |
| `eks_cluster_name` | `string`       | Name of the EKS cluster                            |
| `aws_region`       | `string`       | AWS region of the EKS cluster                      |
| `default_labels`   | `map(string)`  | Default labels applied to CronJob and templates    |
| `cronjobs`         | `list(object)` | List of cronjob definitions (see schema below)     |

## 📦 CronJob Object Schema

This is the schema for each object in the `cronjobs` list input.
| Name                  | Type                   | Description                                         |
|-----------------------|------------------------|-----------------------------------------------------|
| `enabled`             | `bool`                 | Whether to create this CronJob                      |
| `cronjob_name`        | `string`               | Name of the CronJob                                 |
| `cronjob_image`       | `string`               | Container image for the CronJob                     |
| `cronjob_command`     | `list(string)`         | Command to run in the container                     |
| `cronjob_schedule`    | `string`               | Cron schedule string                                |
| `cronjob_timezone`    | `string`               | Timezone for scheduling                             |
| `service_account_name`| `string` (optional)    | K8s ServiceAccount to use                           |
| `env_vars`            | `list(object)` (opt)   | Environment variables as `{ name, value }`          |
| `labels`              | `map(string)` (opt)    | Labels for the CronJob                              |
| `resources`           | `object` (optional)    | Resource `limits` and `requests` for CPU/memory     |
| `tolerations`         | `list(object)` (opt)   | Tolerations for node scheduling                     |
| `node_selector`       | `map(string)` (opt)    | Node selector for pod placement                     |


## 🧪 Testing

To test locally:

1. Clone this repo.
2. Create a test `main.tf` using the example usage.
3. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4.	Validate the CronJob in your cluster using:
  ```bash
  kubectl get cronjobs -n <namespace>
  ```

  ## 🧠 Notes

- This module sets `concurrency_policy = "Replace"` by default.
- Set `suspend = true` in the CronJob object to disable a specific job.
- Uses `restartPolicy = OnFailure` for retrying failed jobs.
- Customize `tolerations` and `node_selector` as needed to control scheduling behavior.
- Follow your internal naming conventions and monitoring policies for consistency and compliance.