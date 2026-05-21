output "alb_sg_id"       { value = module.security_groups.alb_sg_id }
output "eks_nodes_sg_id" { value = module.security_groups.eks_nodes_sg_id }
output "rds_sg_id"       { value = module.security_groups.rds_sg_id }
