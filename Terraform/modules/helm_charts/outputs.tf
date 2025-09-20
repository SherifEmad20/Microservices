output "helm_release_name" {
    description = "The name of the helm release"
    value       = helm_release.this.name
}

output "helm_release_version" {
    description = "The version of the helm release"
    value       = helm_release.this.version
}

output "helm_release_namespace" {
    description = "The namespace of the helm release"
    value       = helm_release.this.namespace
}

output "helm_release_status" {
    description = "The status of the helm release"
    value       = helm_release.this.status
}

