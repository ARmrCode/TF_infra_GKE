output "kubeconfig" {
  value = <<EOT
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${google_container_cluster.this.master_auth[0].cluster_ca_certificate}
    server: https://${google_container_cluster.this.endpoint}
  name: ${google_container_cluster.this.name}
contexts:
- context:
    cluster: ${google_container_cluster.this.name}
    user: ${google_container_cluster.this.name}
  name: ${google_container_cluster.this.name}
current-context: ${google_container_cluster.this.name}
users:
- name: ${google_container_cluster.this.name}
  user:
    token: ${data.google_client_config.current.access_token}
EOT
  sensitive = true
}


output "config_host" {
  value = "https://${data.google_container_cluster.main.endpoint}"
}

output "config_token" {
  value = data.google_client_config.current.access_token
}

output "config_ca" {
  value = base64decode(
    data.google_container_cluster.main.master_auth[0].cluster_ca_certificate,
  )
}

output "name" {
  value = google_container_cluster.this.name
}
