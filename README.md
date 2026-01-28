# Azure DevOps CI/CD with AKS (Node.js Application)

## Project Overview

This project demonstrates a **real-world, end-to-end CI/CD implementation on Microsoft Azure** using **Azure DevOps, Azure Container Registry (ACR), and Azure Kubernetes Service (AKS)**.

A containerized **Node.js application** is built and pushed to ACR using a **self-hosted Azure DevOps agent**, then automatically deployed to AKS using a **separate CD pipeline**.

This project intentionally includes **real debugging scenarios** such as image architecture mismatches, CrashLoopBackOff, ImagePullBackOff, and authentication issues—exactly the kind of problems faced in production environments.

---

## Architecture

```
Developer
   ↓ (git push)
Azure Repos
   ↓
Azure DevOps CI Pipeline (Self-hosted VM Agent)
   ↓
Azure Container Registry (ACR)
   ↓
Azure DevOps CD Pipeline
   ↓
Azure Kubernetes Service (AKS)
   ↓
LoadBalancer Public IP
```

---

## Technologies Used

* **Node.js** – Application runtime
* **Docker** – Containerization
* **Azure Repos** – Source control
* **Azure DevOps Pipelines** – CI & CD
* **Self-hosted Linux Agent (Azure VM)** – Pipeline execution
* **Azure Container Registry (ACR)** – Private image registry
* **Azure Kubernetes Service (AKS)** – Container orchestration
* **kubectl** – Kubernetes management

---

## CI Pipeline (Build & Push)

### What CI Does

* Triggered on `main` branch
* Builds Docker image using Dockerfile
* Tags image using Azure DevOps `Build.BuildId`
* Pushes image to Azure Container Registry

### Why This Matters

* Ensures consistent builds
* No dependency on developer machines
* Versioned images for rollback

---

## CD Pipeline (Deploy to AKS)

### What CD Does

* Pulls Kubernetes manifests from repo
* Deploys application to AKS
* Updates deployment automatically on new image

### Deployment Strategy

* Kubernetes `Deployment`
* Kubernetes `Service` (LoadBalancer)

---

## Kubernetes Configuration

### Deployment

* Runs Node.js container
* Pulls image from private ACR
* Exposes port 3000

### Service

* Type: `LoadBalancer`
* Exposes application publicly

---

## Major Issues Faced & Debugging

### CrashLoopBackOff

**Root Cause:**

* Docker image built for `amd64`
* AKS nodes were `arm64`

**Error:**

```
exec /usr/local/bin/docker-entrypoint.sh: exec format error
```

**Resolution:**

* Verified node architecture using:

  ```bash
  kubectl describe node | grep Architecture
  ```
* Recreated AKS cluster with compatible architecture

---

### ImagePullBackOff

**Root Cause:**

* Image tag mismatch between CI and Kubernetes manifest

**Resolution:**

* Verified tags in ACR:

  ```bash
  az acr repository show-tags --name projectdemo1acr --repository projectdemo
  ```
* Aligned deployment image tag with CI output

---

### Authentication & Service Connection Issues

**Root Cause:**

* Azure DevOps organization and Azure subscription mismatch
* Expired free trial account

**Resolution:**

* Created App Registration manually
* Assigned `Contributor` and `AcrPush` roles
* Used Service Principal–based service connections

---

## Security Best Practices Followed

* No secrets stored in source code
* Least-privilege access using Azure RBAC
* Private ACR
* AKS pulls images using managed identity

---

## Key Learnings

* CI/CD must match runtime architecture
* Containers should be fully self-contained
* `kubectl logs` and `kubectl describe` are critical debugging tools
* Self-hosted agents mirror real enterprise environments
* Infrastructure issues are often the root cause—not application code

---

## ✅ Final Outcome

* CI/CD fully automated
* Application accessible via AKS LoadBalancer IP
* No local machine dependency
* Production-style DevOps workflow implemented

---
