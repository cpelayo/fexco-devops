FEXCO DevOps Take-Home Assessment

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


Azure Requirements:
- Azure subscription with rights to create resource groups, AKS, and networking
- Service Principal or OIDC setup for authentication in GitHub Actions
- Storage account and container for Terraform remote backend (configured in backend.tf)

##############
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

##############
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

Teardown Instructions
1. Go to GitHub Actions -> Terraform CI/CD
2. Select the same run that applied the plan
3. Confirm manual approval in Review Deployments; check on production and approve and deploy.

##############
Verify Backend configured

Github -> Actions -> Any Workflow -> Terraform Plan -> Terraform intit
You shold see the message
Successfully configured the backend "azurerm"!

##############
How to verify Network Policy

az aks get-credentials \
  --name aks-cluster \
  --resource-group aks-demo-rg


kubectl get ns --show-labels
kubectl get networkpolicy -A

You should see something like:

NAME               POD-SELECTOR   AGE
allow-http-only    <all>          1m

Try deploying a pod on a non-80 port:

kubectl run test-server \
  --image=hashicorp/http-echo

hashicorp/http-echo listens in port 5678, a non 80 port

Then test from another pod:

kubectl get pod -o wide

kubectl exec -it <grafana-pod-name> -- sh
curl -v http://<test-server-ip>:<5678>

should work!

after applying the policy, the same test should fail.

##############
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


