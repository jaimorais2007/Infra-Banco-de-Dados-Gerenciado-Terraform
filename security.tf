# Libera, no security group da instância EC2 que roda o Postgres (docker-compose),
# o acesso vindo da Lambda de autenticação (Lambda-Function-Serverless). A Lambda
# não fala com o Service ClusterIP do k3s (não é roteável de fora do cluster) —
# ela acessa o Postgres diretamente pelo IP do host (ver output "host_ip"),
# por isso essa liberação é feita no nível do security group do EC2.
data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = "techchallenge-terraform-state-s3"
    key    = "auth-service/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_lambda" {
  security_group_id            = var.app_server_security_group_id
  description                  = "Postgres a partir da Lambda de autenticacao"
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = data.terraform_remote_state.lambda.outputs.lambda_security_group_id
}
