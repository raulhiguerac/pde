variable "airflow_secrets" {
  description = "variable that contains all the secrets (user_db,password,fernet-key,etc)"
  type = map(any)
}