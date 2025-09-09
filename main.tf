resource "local_file" "flux_private_key" {
  content         = module.tls_private_key.private_key_pem
  filename        = "${path.module}/flux_id_rsa"
  file_permission = "0600"
}

module "tls_private_key" {
    source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
    algorithm = "RSA"
}

module "github_repository" {
    source = "github.com/den-vasyliev/tf-github-repository"
    github_owner = var.GITHUB_OWNER
    github_token = var.GITHUB_TOKEN
    repository_name = var.FLUX_GITHUB_REPO
    public_key_openssh = module.tls_private_key.public_key_openssh
    public_key_openssh_title = "flux0"
}

module "gke_cluster" {
    source = "./tf-google-gke-cluster"
    GOOGLE_REGION = var.GOOGLE_REGION
    GOOGLE_PROJECT = var.GOOGLE_PROJECT
    GKE_NUM_NODES = 2
}

resource "local_file" "kubeconfig" {
  content  = module.gke_cluster.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

module "flux_bootstrap" {
  source            = "./tf-fluxcd-flux-bootstrap"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
  private_key       = module.tls_private_key.private_key_pem
  config_path       = local_file.kubeconfig.filename
}


