terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "2.9.0"
    # }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "automatethingandrei"
    container_name       = "terraform-state"
    key                  = "automate-all-the-things.tfstate"
    use_azuread_auth     = true
  }
}



# ----------------- Azure -----------------

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# ----------------- Helm -----------------

# data "aws_eks_cluster_auth" "default" {
#   name = aws_eks_cluster.cluster.id
# }

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)

#     token = data.aws_eks_cluster_auth.default.token
#   }
# }
