module "app_cronjobs" {
  source    = "github.com/paulsony13/k8-cronjob.git/?ref=main"
  namespace = "default"
  eks_cluster_name = "cluster-name"
  aws_region = "us-east-1"
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
    },
        {
      enabled          = true
      cronjob_name     = "db-backup-2"
      cronjob_image    = "postgres:15"
      cronjob_command  = ["sh", "-c", "pg_dump -h db -U user dbname > /backup.sql"]
      cronjob_schedule = "0 2 * * *"
      cronjob_timezone = "UTC"
    },

    /// Add more cronjobs as needed
  ]
}
