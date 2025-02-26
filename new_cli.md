Prepare backend for Azure
az group create --name terraform-state-rg --location westeurope
az storage account create --name automatethingandrei --resource-group terraform-state-rg --location westeurope --sku Standard_LRS --encryption-services blob --min-tls-version TLS1_2
az storage container create   --name terraform-state   --account-name automatethingandrei   --public-access off
<!-- Enable Ingress in AKS (possibly optional) -->
<!-- az aks enable-addons --resource-group myResourceGroup --name myAKSCluster --addons http_application_routing -->
ToDo:
- Write any automation script that customizes TF files (think about it a bit)
- - default location is east us
- PRICE: AKS+NAT was working for 5 hours