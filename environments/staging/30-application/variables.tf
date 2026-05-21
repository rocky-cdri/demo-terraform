variable "aws_region"         { type = string; default = "ap-northeast-2" }
variable "kubernetes_version" { type = string; default = "1.29" }
variable "db_password"        { type = string; sensitive = true }
variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
  }))
}
