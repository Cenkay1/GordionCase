# Graylog Helm Installation Guide

This document provides instructions for installing Graylog using Helm in a Kubernetes environment.

## Prerequisites

- Kubernetes cluster must be up and running.
- Helm must be installed on your local machine.

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
