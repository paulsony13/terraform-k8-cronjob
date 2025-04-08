module "app_cronjobs" {
  source    = "github.com/paulsony13/k8-cronjob.git//modules/cronjob?ref=main"
  namespace = "namespace"
  eks_cluster_name = "my-cluster"
  aws_region = "us-east-1"
  default_labels = {
    "team"    = "devops"
    "managed" = "terraform"
  }
  cronjobs = [
    {
      enabled          = true
      cronjob_name     = "s3-cleaner"
      cronjob_image    = "amazon/aws-cli:latest"
      cronjob_command  = ["sh", "-c", "aws s3 rm s3://my-bucket/tmp/ --recursive"]
      cronjob_schedule = "0 * * * *"
      cronjob_timezone = "UTC"
      enabled          = true
      env_vars = [
        { name = "AWS_REGION", value = "us-west-2" }
      ]
      labels = {
        "app" = "s3-cleaner"
      }
    },
    {
      enabled          = true
      cronjob_name     = "db-backup"
      cronjob_image    = "postgres:15"
      cronjob_command  = ["sh", "-c", "pg_dump -h db -U user dbname > /backup.sql"]
      cronjob_schedule = "0 2 * * *"
      cronjob_timezone = "UTC"
    }
    /// Add more cronjobs as needed
  ]
}
