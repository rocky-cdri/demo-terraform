# Terraform AWS Infrastructure

이 저장소는 `myapp`의 AWS 인프라를 Terraform으로 관리합니다. 환경은 `dev`, `staging`, `prod`로 분리되어 있고, 각 환경은 의존성 순서에 따라 `networking`, `security`, `application` 레이어로 나뉩니다.

## 구성 개요

```text
environments/
  dev/
    10-networking/     # VPC, Subnet, IGW, NAT Gateway
    20-security/       # ALB, EKS Node, RDS Security Group
    30-application/    # EKS, RDS PostgreSQL, ALB
  staging/
    10-networking/
    20-security/
    30-application/
  prod/
    10-networking/
    20-security/
    30-application/

modules/
  vpc/
  security-groups/
  eks/
  rds/
  alb/
```

레이어 간 의존성은 Terraform remote state로 연결됩니다.

1. `10-networking`이 VPC와 서브넷을 생성합니다.
2. `20-security`가 networking state의 `vpc_id`를 참조해 보안 그룹을 생성합니다.
3. `30-application`이 networking/security state를 참조해 EKS, RDS, ALB를 생성합니다.

## 생성 리소스

| 모듈 | 주요 리소스 |
| --- | --- |
| `vpc` | VPC, public/private subnet, Internet Gateway, NAT Gateway, route table |
| `security-groups` | ALB, EKS node, RDS 보안 그룹 |
| `eks` | EKS cluster, managed node group, cluster/node IAM role |
| `rds` | PostgreSQL RDS instance, DB subnet group, parameter group |
| `alb` | Application Load Balancer, default target group, HTTP/HTTPS listener |

## 환경별 차이

| 환경 | NAT Gateway | RDS | EKS 노드 | ALB HTTPS |
| --- | --- | --- | --- | --- |
| `dev` | 단일 NAT Gateway | `db.t3.micro`, 20GB, Multi-AZ 비활성, 삭제 방지 비활성 | Spot 중심 | HTTP only |
| `staging` | 단일 NAT Gateway | `db.t3.small`, 50GB, Multi-AZ 비활성, 삭제 방지 비활성 | Spot 중심 | HTTP only |
| `prod` | AZ별 NAT Gateway | `db.r6g.large`, 100GB, Multi-AZ 활성, 삭제 방지 활성 | On-demand + Spot | `certificate_arn` 지정 시 HTTPS |

기본 리전은 `ap-northeast-2`입니다.

## 사전 준비

- Terraform `>= 1.5.0`
- AWS Provider `~> 5.0`
- AWS 인증 정보
- 각 환경의 S3 backend bucket
- DynamoDB lock table

현재 backend 설정은 다음 리소스가 이미 존재한다고 가정합니다.

| 환경 | S3 bucket | DynamoDB table |
| --- | --- | --- |
| `dev` | `myapp-tfstate-dev` | `terraform-state-lock` |
| `staging` | `myapp-tfstate-staging` | `terraform-state-lock` |
| `prod` | `myapp-tfstate-prod` | `terraform-state-lock` |

Terraform backend는 Terraform 자체로 자동 생성되지 않습니다. 최초 실행 전 S3 bucket과 DynamoDB table을 별도로 준비해야 합니다.

## 변수 파일

각 레이어는 자체 `terraform.tfvars`를 사용합니다.

- `10-networking`: `aws_region`, `vpc_cidr`, `azs`, `public_subnets`, `private_subnets`
- `20-security`: `aws_region`
- `30-application`: `aws_region`, `kubernetes_version`, `node_groups`, `db_password`
- `prod/30-application`: 위 항목에 더해 `certificate_arn` 사용 가능

`db_password`는 sensitive 변수입니다. 저장소에 실제 비밀번호를 커밋하지 말고 환경 변수나 별도 비밀 관리 도구로 전달하는 방식을 권장합니다.

```bash
export TF_VAR_db_password='change-me'
```

## 배포 순서

환경별로 반드시 아래 순서대로 적용합니다.

```bash
cd environments/dev/10-networking
terraform init
terraform plan
terraform apply

cd ../20-security
terraform init
terraform plan
terraform apply

cd ../30-application
terraform init
terraform plan
terraform apply
```

`staging` 또는 `prod`는 경로의 환경명만 변경해서 같은 순서로 실행합니다.

```bash
cd environments/prod/10-networking
terraform init
terraform plan
terraform apply
```

## 출력값

주요 출력값은 다음과 같습니다.

- `10-networking`: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `nat_gateway_ids`
- `20-security`: `alb_sg_id`, `eks_nodes_sg_id`, `rds_sg_id`
- `30-application`: `eks_cluster_name`, `eks_cluster_endpoint`, `rds_endpoint`, `alb_dns_name`

민감 출력값은 Terraform에서 `sensitive`로 표시됩니다.

## EKS 접속

Application 레이어 적용 후 다음 명령으로 kubeconfig를 갱신할 수 있습니다.

```bash
aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name myapp-dev-cluster
```

환경에 따라 클러스터 이름은 `myapp-dev-cluster`, `myapp-staging-cluster`, `myapp-prod-cluster` 형식입니다.

## 운영 명령

포맷 확인:

```bash
terraform fmt -recursive -check
```

현재 레이어 검증:

```bash
terraform validate
```

특정 환경 전체를 제거할 때도 의존성의 역순으로 진행합니다.

```bash
cd environments/dev/30-application
terraform destroy

cd ../20-security
terraform destroy

cd ../10-networking
terraform destroy
```

`prod`의 RDS는 삭제 방지가 활성화되어 있어 destroy 전에 `deletion_protection` 정책을 명시적으로 변경해야 할 수 있습니다.

## 주의 사항

- Application 레이어는 하위 레이어의 remote state를 참조하므로 networking/security가 먼저 적용되어 있어야 합니다.
- ALB 기본 target group의 health check path는 `/health`입니다.
- VPC 서브넷에는 EKS Load Balancer Controller에서 사용하는 `kubernetes.io/role/elb`, `kubernetes.io/role/internal-elb` 태그가 포함됩니다.
- HTTPS listener는 `certificate_arn`이 비어 있지 않을 때만 생성됩니다.
- `architecture.html`에는 현재 구성을 설명하는 아키텍처 다이어그램이 포함되어 있습니다.
