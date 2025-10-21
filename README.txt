FEXC O DevOps Take-Home Assessment

Objective
Provision an Azure Kubernetes Service (AKS) cluster using Terraform, deploy a simple Helm workload to it, and manage the lifecycle using a GitHub Actions CI/CD pipeline.

Prerequisites 
- Terraform CLI
- GitHub CLI
- Azure CLI 
- kubectl 
- Code Editor (Visual Studio)

Accounts for
- github
- Azure

Versions Used
- Terraform v1.13.4
- git version 2.50.1
- azure-cli 2.78.0
- kubectl v1.34.1
##########################
CLI login

azure
az login

Kubernetes 
# Get AKS cluster credentials (admin context)
az aks get-credentials \
  --resource-group <RESOURCE_GROUP> \
  --name <CLUSTER_NAME> \
  --admin
##########################

Azure Requirements:
- Azure subscription with rights to create resource groups, AKS, and networking
- Service Principal or OIDC setup for authentication in GitHub Actions
- Storage account and container for Terraform remote backend (configured in backend.tf)
##########################

Setup Steps and How to Trigger the Pipeline
1. Clone the repository:
   git clone https://https://github.com/cpelayo/fexco-devops
   cd <path/fexco-devops>

2. Set GitHub Secrets:
   ARM_CLIENT_ID
   ARM_CLIENT_SECRET
   ARM_TENANT_ID
   ARM_SUBSCRIPTION_ID

3. Pipeline Triggers:
   - Runs automatically on each push to the master branch.
   - Can be triggered manually in the Actions tab -> Terraform CI/CD -> Run workflow.

4. Pipeline Stages:
   - Lint & Validate: Runs terraform fmt and terraform validate.
   - Plan: Generates and uploads a Terraform plan as an artifact.
   - Apply: Requires manual approval; applies infrastructure.
   - Destroy: Requires manual approval; stage to clean up all resources.
##########################

How to Verify the Deployed Workload
1. Retrieve AKS credentials:
   az aks get-credentials -n <aks-cluster-name> -g <resource-group>

2. List pods:
   kubectl get pods -A

3. Check LoadBalancer service:
   kubectl get svc

   Example output:
   NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
   nginx        LoadBalancer   10.0.123.45    20.12.34.56     80:31000/TCP   2m

4. Open the EXTERNAL-IP in your browser to verify the workload.
##########################
Teardown Instructions
1. Go to GitHub Actions -> Terraform CI/CD
2. Select the same run that applied the plan
3. Confirm manual approval in Review Deployments; check on production and approve and deploy.
##########################

az aks get-credentials \
  --resource-group aks-demo-rg \
  --name aks-demo-cluster \
  --admin

kubectl run test-server --image=python:3.9-slim --restart=Never \
--port=5678 \
--command -- python -m http.server 5678

kubectl get pod  -o wide

kubectl exec -it grafana-544f88698d-cbxxx -- sh

curl -v http://10.244.0.205:5678



Design Trade-offs and Shortcuts Taken
- Used Service Principal instead of OIDC to simplify configuration.
- Single-node AKS cluster to reduce cost and complexity.
- Simple Helm chart (grafana) to focus on CI/CD integration.
- Azure remote backend for consistent state management.
- Secrets handled via GitHub Secrets instead of Vault.
- No private registry or TLS cert manager (optional stretch goal).

Future Improvements (Optional Stretch Goals)
- Add TLS with self-signed certificates for ingress.
- Add observability with Prometheus and Grafana.
- Add multi-environment structure (dev, stage, prod) using Terraform workspaces.
- Integrate policy scanning (tfsec, checkov) in the pipeline.
