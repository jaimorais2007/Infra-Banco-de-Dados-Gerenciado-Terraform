variable "kubeconfig_path" {
  description = "Caminho do kubeconfig do k3s local"
  type        = string
  default     = "/etc/rancher/k3s/k3s.yaml"
}

variable "k8s_namespace" {
  description = "Namespace onde a aplicacao e o Service do banco sao criados"
  type        = string
  default     = "default"
}

variable "repo_root" {
  description = "Caminho da raiz do repositorio (para rodar docker compose e o script do k3s)"
  type        = string
  default     = ".."
}

variable "db_port" {
  description = "Porta do PostgreSQL publicada pelo docker-compose no host"
  type        = number
  default     = 5432
}

variable "aws_region" {
  description = "Região AWS onde a instância do Tech Challenge está provisionada"
  type        = string
  default     = "us-east-1"
}

variable "app_server_security_group_id" {
  description = "Security group da instância EC2 que roda o docker-compose do Postgres (tech-challenge-fase2-sg)"
  type        = string
  default     = "sg-0c26ea8d92fb553e1"
}
