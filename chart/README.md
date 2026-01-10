# Crashing App Helm Chart

Helm chart for deploying the crashing-app Flask application to Kubernetes.

## Prerequisites

- Kubernetes cluster (Minikube, Kind, etc.)
- Helm 3.x installed
- Docker image built and available

## Quick Start

### Install the chart

```bash
helm install crashing-app ./chart
```

### Install with custom release name

```bash
helm install my-release ./chart
```

### Install with custom values

```bash
helm install crashing-app ./chart --set replicaCount=3
```

### Install with values file

```bash
helm install crashing-app ./chart -f my-values.yaml
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `2` |
| `image.repository` | Image repository | `crashing-app` |
| `image.tag` | Image tag | `1.1` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `NodePort` |
| `service.port` | Service port | `80` |
| `service.targetPort` | Container port | `8080` |
| `service.nodePort` | NodePort (if type is NodePort) | `30080` |
| `config.appMode` | Application mode (ConfigMap) | `Debug` |
| `secret.apiKey` | API key (base64 encoded) | `MTIzNDUtc2VjcmV0` |

## Common Commands

### Upgrade an existing release

```bash
helm upgrade crashing-app ./chart
```

### Uninstall the chart

```bash
helm uninstall crashing-app
```

### Dry run (see what will be deployed)

```bash
helm install crashing-app ./chart --dry-run --debug
```

### Template rendering (see generated YAML)

```bash
helm template crashing-app ./chart
```

### List installed releases

```bash
helm list
```

## Resources Created

This chart creates the following Kubernetes resources:

- **Deployment** - Manages the application pods
- **Service** - Exposes the application (NodePort)
- **ConfigMap** - Stores non-sensitive configuration (APP_MODE)
- **Secret** - Stores sensitive data (API_KEY)

## Accessing the Application

After installation with Minikube:

```bash
minikube service crashing-app
```

Or access directly via NodePort:

```bash
curl http://$(minikube ip):30080
```
