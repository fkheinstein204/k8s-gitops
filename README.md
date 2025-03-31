# 🧪 Self-Hosted Kubernetes Homelab – Dev & Prod Clusters

This repository documents my personal Kubernetes homelab designed to explore and experiment with modern cloud-native tools and DevOps practices in a production-like environment.

## 💡 Overview

I operate two self-hosted Kubernetes clusters (Dev & Prod), each with:

- ✅ **32 vCPU / 32 GB RAM** – Bare-metal powered
- ✅ Provisioned using **KubeSpray**
- ✅ Managed via **GitOps** using **Flux**

## 🔧 Cluster Architecture

### 🔹 Dev Cluster
- CNI: **Calico**
- Purpose: Development, testing, and validation

### 🔹 Prod Cluster
- CNI: **Cilium**
- Purpose: Stable production-like workloads, security & observability

## 🚀 Stack

### ☁️ Networking
- Ingress Controller
- **Traefik**
- **MetalLB**
- **External DNS**

### 🗃 Storage
- **NFS Provisioner**
- **Longhorn**

### 📊 Monitoring & Observability
- **Prometheus**
- **Grafana**
- **Loki**
- **InfluxDB**

### 🔐 Security & Secrets
- **Keycloak** (OIDC authentication)
- **Sealed Secrets** (legacy workloads)
- **HashiCorp Vault** – Centralized secrets management
- **External Secrets** – Secure secret injection from Vault to Kubernetes

### 📦 Container Registry
- **Harbor**

### 🔁 Backup & Restore
- **Velero**

### 🔁 GitOps
- **Flux**

## 🛠️ Use Cases & Practices

- GitOps CI/CD pipelines
- Secrets and identity management
- Self-healing applications
- Disaster recovery and backups
- Advanced network policies
- Infrastructure-as-Code (IaC) experiments

---

_This lab mirrors real-world production environments and is a sandbox for continuous learning and experimentation with Kubernetes and Cloud Native tools._

