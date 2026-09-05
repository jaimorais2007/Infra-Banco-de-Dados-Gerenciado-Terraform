# Infra-Banco-de-Dados-Gerenciado-Terraform

Sobe o PostgreSQL via `docker compose up -d db` na instância EC2 do Tech Challenge e o
expõe dentro do cluster k3s através de um `Service` sem selector + `Endpoints` manuais
apontando para o IP do host (o container roda no dockerd, não no containerd do k3s).

> Pré-requisito: a instância já deve ter o k3s no ar (repositório
> [`Infraestrutura-Kubernetes-Terraform`](https://github.com/jaimorais2007/Infraestrutura-Kubernetes-Terraform))
> antes de aplicar este repositório.

## Acesso da Lambda de autenticação ao Postgres

O `docker-compose` publica a porta 5432 diretamente na interface de rede do host
(`ports: "5432:5432"`), então o Postgres também é alcançável fora do k3s pelo IP do EC2
(`output "host_ip"`) — o `Service` ClusterIP do k8s só é roteável de dentro do cluster,
então a Lambda (fora do k3s) **não consegue** usá-lo.

`security.tf` libera essa porta no security group do EC2
(`tech-challenge-fase2-sg` / `sg-0c26ea8d92fb553e1`) apenas para o security group criado
pela Lambda em [`Lambda-Function-Serverless`](https://github.com/jaimorais2007/Lambda-Function-Serverless),
lido via `terraform_remote_state`. Por isso a Lambda precisa ser aplicada **antes**
deste repositório (ou antes de reaplicar depois de uma mudança).

Ordem de apply recomendada:

1. `Infraestrutura-Kubernetes-Terraform` (cluster k3s no ar)
2. Este repositório (banco de dados)
3. `Lambda-Function-Serverless` (usa o `host_ip` daqui como `rds_hostname`)
4. Este repositório de novo (aplica a regra de security group liberando a Lambda)
5. `Infraestrutura-Kubernetes-Terraform` de novo (API Gateway na frente da Lambda)

## ⚠️ Permissões AWS necessárias

O usuário IAM usado no projeto (`dev-techchallenge`) hoje só tem permissão de
leitura em EC2 e de gerenciar Security Groups. Isso **não é suficiente** para este
repositório: aplicar `security.tf` exige `ec2:AuthorizeSecurityGroupIngress` (OK) e
acesso de leitura ao state remoto da Lambda em S3 (`s3:GetObject` no bucket
`meu-bucket-terraform-state`), que atualmente **não está liberado** para esse usuário.
