# Task 1: Infrastructure Setup

**Status:** ✅ Completed

## Objective
Install Docker, Minikube, and Kubectl for local Kubernetes development.

---

## Installed Tools

### 1. Docker

```
docker version
```

| Component | Version |
|-----------|---------|
| Client | 29.1.3 |
| Server (Docker Desktop) | 4.55.0 (213807) |
| API version | 1.52 |
| OS/Arch | darwin/arm64 |
| containerd | v2.2.0 |
| runc | 1.3.4 |

### 2. Minikube

```
minikube version
```

| Component | Version |
|-----------|---------|
| Minikube | v1.37.0 |

### 3. Kubectl

```
kubectl version --client
```

| Component | Version |
|-----------|---------|
| Client | v1.34.1 |
| Kustomize | v5.7.1 |

---

## Cluster Setup

### Start Minikube Cluster

```bash
minikube start
```

### Verify Cluster is Running

```bash
kubectl get nodes
```

**Output:**
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   45s   v1.34.0
```

✅ Cluster is up and running with a single node in `Ready` status.
