module "app_cronjobs" {
  source    = "github.com/paulsony13/k8-cronjob.git/?ref=main"
  namespace = "namespace"
  eks_cluster_name = "cluster-name"
  aws_region       = "us-east-1"
  default_labels = {
    "team"    = "devops"
    "managed" = "terraform"
  }
  cronjobs = [
    {
      cronjob_name     = "s3-cleaner"
      cronjob_image    = "amazon/aws-cli:latest"
      cronjob_command  = ["sh", "-c", "aws s3 rm s3://my-bucket/tmp/ --recursive"]
      cronjob_schedule = "0 * * * *"
      cronjob_timezone = "UTC"
      enabled          = true
      env_vars = [
        { name = "AWS_REGION", value = "us-west-2" }
      ]
      node_selector = {
        "kubernetes.io/os" = "linux"
      }
      tolerations = [
        {
          key      = "dedicated"
          operator = "Equal"
          value    = "batch"
          effect   = "NoSchedule"
        }
      ]
      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
        limits = {
          cpu    = "200m"
          memory = "256Mi"
        }
      }
      service_account_name = "s3-job-service-account"
      labels = {
        "app" = "s3-cleaner"
      }
    },
    /// Add more cronjobs as needed    
  ]
}
