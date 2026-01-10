# Task 6: Helm Chart Migration

**Status:** ✅ Completed

## Objective

Migrate raw Kubernetes manifests into a Helm chart for easier deployment management, templating, and configuration.

---

## What Was Done

### 1. Created Helm Chart Structure

```
chart/
├── Chart.yaml              # Chart metadata
├── README.md               # Chart documentation
├── values.yaml             # Default configurable values
└── templates/
    ├── configmap.yaml      # Templated ConfigMap
    ├── deployment.yaml     # Templated Deployment
    ├── secret.yaml         # Templated Secret
    └── service.yaml        # Templated Service
```

### 2. Migrated Raw Manifests to Helm Templates

| Original File | Migrated To | Status |
|---------------|-------------|--------|
| `deployment.yaml` | `chart/templates/deployment.yaml` | ✅ Deleted original |
| `service.yaml` | `chart/templates/service.yaml` | ✅ Deleted original |
| `configmap.yaml` | `chart/templates/configmap.yaml` | ✅ Deleted original |
| `secrets.yaml` | `chart/templates/secret.yaml` | ✅ Deleted original |
| `pod.yaml` | Not needed (Deployment manages pods) | ✅ Deleted |

### 3. Added Checksum Annotations (Best Practice)

Added automatic pod restart on ConfigMap/Secret changes:

```yaml
# chart/templates/deployment.yaml
template:
  metadata:
    annotations:
      checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
      checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
```

**Why?** Kubernetes doesn't restart pods when ConfigMap/Secret changes. The checksum annotation changes when the content changes, triggering a pod rollout automatically.

---

## Configuration (values.yaml)

```yaml
replicaCount: 2

image:
  repository: crashing-app
  tag: "1.1"
  pullPolicy: IfNotPresent

service:
  type: NodePort
  port: 80
  targetPort: 8080
  nodePort: 30080

config:
  appMode: "Production"

secret:
  apiKey: "MTIzNDUtc2VjcmV0"
```

---

## Helm Commands Reference

| Command | Description |
|---------|-------------|
| `helm install crashing-app ./chart` | Install the chart |
| `helm upgrade crashing-app ./chart` | Apply changes after modifying values.yaml |
| `helm upgrade crashing-app ./chart --dry-run` | Preview changes without applying |
| `helm uninstall crashing-app` | Remove all resources |
| `helm list` | Show installed releases |
| `helm history crashing-app` | Show revision history |
| `helm rollback crashing-app <revision>` | Rollback to a previous version |

---

## Workflow: Updating the Application

After making changes to `values.yaml`:

```bash
# Just run this - pods restart automatically if config changed
helm upgrade crashing-app ./chart
```

No need to run `kubectl rollout restart` thanks to the checksum annotations!

---

## Accessing the Application (Minikube)

```bash
# Open tunnel to access the app in browser
minikube service crashing-app-service
```

**Note:** The tunnel must stay open in the terminal. You don't need to restart it after `helm upgrade`.

---

## Key Takeaways

| Feature | Raw Manifests | Helm Chart |
|---------|---------------|------------|
| Templating | ❌ Hardcoded values | ✅ Dynamic with `{{ .Values.x }}` |
| Configuration | ❌ Edit multiple files | ✅ Single `values.yaml` |
| Version control | ❌ Manual | ✅ Built-in revisions |
| Rollback | ❌ Manual | ✅ `helm rollback` |
| Auto-restart on config change | ❌ No | ✅ With checksum annotations |

---

## Template Syntax Quick Reference

| Syntax | Example | Result |
|--------|---------|--------|
| `{{ .Values.x }}` | `{{ .Values.replicaCount }}` | `2` |
| `{{ .Release.Name }}` | `{{ .Release.Name }}` | `crashing-app` |
| `{{ .Chart.Name }}` | `{{ .Chart.Name }}` | `crashing-app` |
| `{{ include ... \| sha256sum }}` | Checksum of a template | `a1b2c3...` |
