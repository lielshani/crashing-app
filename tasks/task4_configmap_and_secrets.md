# Task 4: ConfigMap and Secrets

**Status:** ✅ Completed

## Objective
Learn how to use ConfigMaps and Secrets to manage configuration and sensitive data in Kubernetes.

---

## Step 1: Create ConfigMap YAML

Created a ConfigMap to store application configuration:

### configmap.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: crashing-app-config
data:
  APP_MODE: "Debug"
```

| Field | Description |
|-------|-------------|
| `apiVersion: v1` | Core API version for ConfigMap resource |
| `kind: ConfigMap` | Resource type for storing non-sensitive configuration |
| `metadata.name` | Unique name for this ConfigMap |
| `data` | Key-value pairs of configuration data |
| `APP_MODE` | Application mode setting (Debug/Production) |

---

## Step 2: Create Secret YAML

Created a Secret to store sensitive data (API key):

### secrets.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: crashing-app-secret
type: Opaque
data:
  API_KEY: MTIzNDUtc2VjcmV0
```

| Field | Description |
|-------|-------------|
| `apiVersion: v1` | Core API version for Secret resource |
| `kind: Secret` | Resource type for storing sensitive data |
| `metadata.name` | Unique name for this Secret |
| `type: Opaque` | Generic secret type (default for arbitrary data) |
| `data` | Key-value pairs (values must be base64 encoded) |
| `API_KEY` | Base64 encoded value (`MTIzNDUtc2VjcmV0` = `12345-secret`) |

**Note:** Values in `data` must be base64 encoded. To encode:
```bash
echo -n "12345-secret" | base64
# Output: MTIzNDUtc2VjcmV0
```

---

## Step 3: Update Pod to Use ConfigMap and Secret

Modified the Pod manifest to inject configuration as environment variables using `envFrom`:

### pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: crashing-app-pod
  labels:
    app: crashing-app
spec:
  containers:
    - name: app
      image: crashing-app:1.0
      ports:
        - containerPort: 8080
      envFrom:
        - configMapRef:
            name: crashing-app-config
        - secretRef:
            name: crashing-app-secret
```

| Field | Description |
|-------|-------------|
| `envFrom` | Injects all keys from ConfigMap/Secret as environment variables |
| `configMapRef` | Reference to ConfigMap (injects `APP_MODE`) |
| `secretRef` | Reference to Secret (injects `API_KEY`) |

---

## Step 4: Apply All Resources

Applied the resources in order:

```bash
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml
kubectl apply -f pod.yaml
```

Output:
```
configmap/crashing-app-config created
secret/crashing-app-secret created
pod/crashing-app-pod created
```

---

## Step 5: Verify Resources

### Check all resources were created:

```bash
kubectl get configmap crashing-app-config
kubectl get secret crashing-app-secret
kubectl get pods crashing-app-pod
```

Output:
```
NAME                  DATA   AGE
crashing-app-config   1      110s

NAME                  TYPE     DATA   AGE
crashing-app-secret   Opaque   1      110s

NAME               READY   STATUS    RESTARTS   AGE
crashing-app-pod   1/1     Running   0          110s
```

### Check Pod logs:

```bash
kubectl logs crashing-app-pod
```

---

## Step 6: Access the Application

### Option 1: Port Forward (for development/testing)

```bash
kubectl port-forward pod/crashing-app-pod 8080:8080
```

This creates a tunnel from `localhost:8080` to the Pod. Access via:
- Browser: http://localhost:8080
- Terminal: `curl http://localhost:8080`

**Note:** Port-forward is temporary - works only while the command runs.

### Option 2: Create a Service (for persistent access)

For production, create a Kubernetes Service instead.

### Verify port is closed:

```bash
lsof -i :8080
```

---

## Key Concepts

### ConfigMap vs Secret

| Aspect | ConfigMap | Secret |
|--------|-----------|--------|
| Purpose | Non-sensitive configuration | Sensitive data (passwords, keys) |
| Encoding | Plain text | Base64 encoded |
| Use Cases | App settings, feature flags | API keys, database passwords |

### Ways to Inject Config into Pods

| Method | Description |
|--------|-------------|
| `envFrom` | Inject ALL keys as env vars |
| `env.valueFrom` | Inject specific keys as env vars |
| `volumeMounts` | Mount as files in the container |

### Port Forward vs Service

| Aspect | Port Forward | Service |
|--------|--------------|---------|
| Saved in YAML | ❌ | ✅ |
| Persistent | ❌ (manual) | ✅ (managed by K8s) |
| Use Case | Quick testing | Production |

---
