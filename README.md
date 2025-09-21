# Python Microservices Infrastructure Deployment Guide

This guide provides step-by-step instructions for deploying a complete Python microservices infrastructure on Azure, including **GitHub self-hosted runners**, **Azure Kubernetes Service (AKS)**, **monitoring**, and **SSL certificate management**.

## **Live URLs and Endpoints**

Once deployment is complete, the following URLs will be available:

### **Application Endpoints**

| Service      | URL                                                                          | Description               |
| ------------ | ---------------------------------------------------------------------------- | --------------------------|
| **Main API** | [Python Microservices](https://application-dev-microservice.s-tech.digital/) | Primary microservices API |

### **Monitoring and Observability**

| Service     | URL                                                                    | Default Credentials   |
| ----------- | ---------------------------------------------------------------------- | --------------------- |
| **Grafana** | [Grafana](https://monitoring-stack-grafana-monitoring.s-tech.digital/) | admin / prom-operator |

## **1. Overview**

This project creates an environment for Python microservices with:

- **Self-hosted GitHub runners** for CI/CD workflows
- **Azure Kubernetes Service (AKS)** for container orchestration
- **Azure Container Registry (ACR)** for container image storage
- **Automated SSL certificate management** with cert-manager
- **NGINX Ingress Controller** for traffic routing
- **Prometheus monitoring stack** for observability
- **Grafana dashboards** for metrics visualization

The deployment process follows a two-phase approach: first setting up the CI/CD infrastructure (GitHub runners), then deploying the application infrastructure (AKS cluster and applications).

## **2. Prerequisites**

Before starting the deployment, ensure you have:

- **Azure CLI** installed and configured (`az login`)
- **Terraform** installed (version 1.0+)
- **kubectl** installed for Kubernetes management
- **Docker** installed and configured
- **Helm** installed (version 3.0+)
- **GitHub repository** with Actions enabled
- **Azure subscription** with appropriate permissions
- **Domain name** for SSL certificates and ingress

---

## **3. Deployment Flow**

The complete deployment follows this sequence:

```tree
Phase 1: CI/CD Infrastructure
├── 1. Configure GitHub Runner
│   ├── a. Apply runner Terraform infrastructure
│   ├── b. Remove old runner instances
│   ├── c. Update runner StatefulSet with fresh token
│   └── d. SSH to runner machine and deploy StatefulSet
│
Phase 2: Application Infrastructure
└── 2. Configure Application Environment
    ├── a. Apply AKS Terraform infrastructure
    ├── b. Apply cluster issuers for SSL certificates
    ├── c. Update GitHub secrets with ACR and kubeconfig
    ├── d. Create application namespace (application-dev)
    ├── e. Run the GitHub Actions workflow
    ├── f. Update domain DNS records with ingress IP
    └── g. Apply Grafana ingress configuration
```

---

## **4. Phase 1: Configure GitHub Runner**

### **Step 1: Apply Runner Terraform Infrastructure**

Navigate to the GitHub runner Terraform directory and deploy the infrastructure:

```bash
# Navigate to the runner Terraform directory
cd github-runner/Terraform

# Initialize Terraform
terraform init

# Review the planned infrastructure
terraform plan

# Apply the infrastructure
terraform apply
```

### **Step 2: Update Runner StatefulSet with Fresh Token**

Generate a new GitHub runner token and update the configuration:

1. **Generate GitHub Runner Token:**

   - Go to your GitHub repository
   - Navigate to **Settings** → **Actions** → **Runners**
   - Click **New self-hosted runner**
   - Copy the registration token

2. **Update the StatefulSet configuration:**

```bash
# Edit the StatefulSet YAML file
vim k8s.yaml

# Update the ConfigMap section with the new token:
data:
  GH_TOKEN: "<your-new-runner-token>"
  GH_URL: "https://github.com/your-username/your-repo"
  GH_WORK: "/work"
  GH_RUNNERGROUP: "default"
```

### **Step 3: SSH to Runner Machine and Apply StatefulSet**

Deploy the GitHub runner on the k3s cluster:

```bash
# SSH to the runner VM
ssh azureuser@<runner-public-ip>

# Verify k3s cluster is running
sudo kubectl get nodes

# Create the runner namespace
sudo kubectl create namespace gh-runner-amazon-linux

# Apply the StatefulSet configuration
sudo kubectl apply -f k8s.yaml

# Verify the runner is deployed and running
sudo kubectl get pods -n gh-runner-amazon-linux
sudo kubectl logs -f <pod-name> -n gh-runner-amazon-linux
```

**Verification:**

- Check GitHub repository settings to confirm runner is online
- Runner should appear as "Idle" in the GitHub Actions runners page

---

## **5. Phase 2: Configure Application Environment**

### **Step 1: Apply AKS Terraform Infrastructure**

Deploy the main application infrastructure:

```bash
# Navigate to the main Terraform directory
cd ../../Terraform

# Initialize Terraform
terraform init

# Review the planned infrastructure
terraform plan

# Apply the infrastructure (this may take 10-15 minutes)
terraform apply
```

### **Step 2: Apply Cluster Issuers**

Configure SSL certificate automation:

```bash
# Get AKS credentials
az aks get-credentials --resource-group <resource-group-name> --name <aks-cluster-name>

# Verify cluster connection
kubectl get nodes

# Apply cluster issuers for SSL certificates
kubectl apply -f Deployment_k8s/ClusterIssuers/cluster-issuer-staging.yaml
kubectl apply -f Deployment_k8s/ClusterIssuers/cluster-issuer-prod.yaml

# Verify cluster issuers are ready
kubectl get clusterissuer
```

### **Step 3: Update GitHub Secrets with ACR and Kubeconfig Values**

Configure GitHub repository secrets for CI/CD pipeline:

1. **Get ACR credentials:**

   ```bash
   # Get ACR login server
   terraform output acr_login_server

   # Get ACR admin username
   terraform output acr_admin_username

   # Get ACR admin password
   terraform output acr_admin_password
   ```

2. **Get kubeconfig:**

   ```bash
   # Get the raw kubeconfig content
   terraform output kube_config_raw
   ```

3. **Update GitHub repository secrets:**
   - Go to **Settings** → **Secrets and variables** → **Actions**
   - Add the following secrets:
     - `ACR_LOGIN_SERVER`: ACR login server URL
     - `ACR_USERNAME`: ACR admin username
     - `ACR_PASSWORD`: ACR admin password
     - `KUBE_CONFIG`: Base64 encoded kubeconfig content

### **Step 4: Create Application Namespace**

Create the development namespace for application deployment:

```bash
# Create the application namespace
kubectl create namespace application-dev

# Label the namespace for monitoring
kubectl label namespace application-dev monitoring=enabled

# Verify namespace creation
kubectl get namespaces
```

### **Step 5: Run the GitHub Actions Workflow**

Trigger the CI/CD pipeline to build and deploy the application:

1. **Push code changes** to trigger the workflow, or
2. **Manually trigger** the workflow from GitHub Actions tab
3. **Monitor the workflow** execution in GitHub Actions

The workflow will:

- Build the Docker image for Python microservices
- Push the image to ACR
- Deploy the application to AKS

### **Step 6: Update Domain DNS Records with Ingress LoadBalancer IP**

Configure DNS for your domain to point to the ingress controller:

```bash
# Get the ingress controller's external IP
$ kubectl -n nginx-ingress get svc

# Look for the EXTERNAL-IP of the nginx-ingress-controller service
# Example output:
NAME                          TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
nginx-ingress-controller      LoadBalancer   10.0.123.45    52.123.45.67     80:32080/TCP,443:32443/TCP
```

**Update your DNS records:**

- Create an **A record** pointing your domain to the external IP
- Example: `api.yourdomain.com` → `52.123.45.67`
- Wait for DNS propagation (can take up to 24 hours)

### **Step 7: Apply Grafana Ingress**

Configure ingress for Grafana monitoring dashboard:

```bash
# Create Grafana ingress configuration
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: microservices-app-ingress
  namespace: monitoring-stack
  annotations:
    cert-manager.io/cluster-issuer: staging
    acme.cert-manager.io/http01-edit-in-place: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /
  labels:
    name: microservices-app-ingress
spec:
  ingressClassName: nginx
  rules:
    - host: monitoring-stack-grafana-monitoring.s-tech.digital
      http:
        paths:
        - pathType: Prefix
          path: /
          backend:
            service:
              name: kube-prometheus-stack-grafana
              port: 
                number: 80
  tls:
    - hosts:
        - monitoring-stack-grafana-monitoring.s-tech.digital
      secretName: secret-tls-stage
EOF

# Verify ingress is created
kubectl get ingress -n monitoring-stack
```

---

## **6. Verification and Testing**

### **Application Health Checks**

```bash
# Check all pods are running
kubectl get pods --all-namespaces

# Verify application deployment
kubectl get pods -n application-dev

# Check ingress status
kubectl get ingress --all-namespaces

# Test application endpoint
curl -k https://api.yourdomain.com/health
```

### **Monitoring Stack Verification**

```bash
# Check monitoring components
kubectl get pods -n monitoring-stack
```

### **SSL Certificate Verification**

```bash
# Check certificate status
kubectl get certificate --all-namespaces

# Verify certificate details
kubectl describe certificate <certificate-name> -n <namespace>

# Test SSL connection
openssl s_client -connect api.yourdomain.com:443 -servername api.yourdomain.com
```

---

## **13. References**

- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [GitHub Actions Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Cert-Manager Documentation](https://cert-manager.io/docs/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Prometheus Operator](https://prometheus-operator.dev/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
