# Values Terraform prints after it finishes building, for convenience.

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region the cluster is in"
  value       = local.region
}

# Copy-paste this after apply to point kubectl at your new cluster.
output "configure_kubectl" {
  description = "Command to connect kubectl to the cluster"
  value       = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.cluster_name}"
}
