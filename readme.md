## Prerequisites

- **Kubernetes Cluster:** You need an existing Kubernetes cluster where you will deploy the applications.
- **Terraform Installed:** Ensure that Terraform is installed on your local machine.
- **Helm Installed:** Helm must be installed to manage Kubernetes applications.
- **Azure CLI Installed:** Make sure the Azure CLI is installed to interact with Azure resources.

## Terraform Workflow

To set up your infrastructure using Terraform, follow these essential steps:

1. **Initialize Terraform:**
   Before you start, initialize your Terraform working directory. This step downloads the necessary provider plugins and sets up your backend configuration. Run the following command:

terraform init

2. **Create a Plan**
    After initialization, you can create an execution plan. This command allows you to preview the changes that Terraform will make to your infrastructure based on your configuration files. Run:

terraform plan

3. **Apply Changes**
     Once you are satisfied with the plan, apply the changes to provision the resources. This command executes the actions defined in your plan and creates the infrastructure. Use the following command:

terraform apply

# Helm Installation Guide

## Installation Steps

### Step 1: Install MongoDB

To install MongoDB for Graylog, run the following command:

# Add Bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install MongoDB
helm install graylog-mongodb -n graylog bitnami/mongodb --version 16.1.1 \
  --set auth.enabled=true \
  --set auth.rootUser=root \
  --set auth.rootPassword=Buaqlik3ky \
  --set auth.usernames[0]=adminuser1 \
  --set auth.passwords[0]=Buaqlik3ky \
  --set auth.databases[0]=graylog


### Step 2: Install OpenSearch

# Install OpenSearch
helm install graylog-opensearch bitnami/opensearch -n graylog --version 1.3.12 \
  --set extraEnvs[0].name=OPENSEARCH_INITIAL_ADMIN_PASSWORD \
  --set extraEnvs[0].value=".rbYI09myXlK3tn"

### Step 3: Install NGINX Ingress Controller

# Add Ingress NGINX repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Install Ingress NGINX
helm install ingress-nginx ingress-nginx/ingress-nginx -n graylog --version 4.0.13

<!-- Default Class Name is nginx. -->

## Note on Kubernetes Management

All operations described in this document were performed using **Lens**, a powerful Kubernetes management application. Lens provides an intuitive interface for managing Kubernetes clusters, making it easier to deploy and monitor applications like Graylog. Utilizing Lens enhances the efficiency and effectiveness of managing Kubernetes resources.

## Additional Considerations

For enhanced security and secret management, it is essential to utilize **Azure Key Vault** or similar applications to store sensitive information such as database passwords, API keys, and other credentials. This ensures that secrets are securely managed and accessed only by authorized applications and users.

Furthermore, it is recommended to store configuration files, such as `.tfvars` files, in a secure storage account. This practice promotes collaboration and consistency among team members while safeguarding sensitive information. By centralizing configuration management, teams can ensure that all members have access to the necessary parameters while minimizing the risk of exposing sensitive data.

## Additional Considerations

For enhanced security and secret management, it is essential to utilize **Azure Key Vault** or similar applications to store sensitive information such as database passwords, API keys, and other credentials. This ensures that secrets are securely managed and accessed only by authorized applications and users.

Furthermore, it is recommended to store configuration files, such as `.tfvars` files, in a secure storage account. This practice promotes collaboration and consistency among team members while safeguarding sensitive information. By centralizing configuration management, teams can ensure that all members have access to the necessary parameters while minimizing the risk of exposing sensitive data.

In addition to the above, it is crucial to include the Helm charts and values files for **Graylog**, **Nginx**, **OpenSearch**, and **MongoDB** within the Terraform process. This integration allows for a more streamlined deployment and management of these components in Kubernetes. By defining the Helm charts and associated values in your Terraform configurations, you can automate the deployment process, ensuring consistency and reducing manual intervention.


