# Task 3: Pod vs Deployment

**Status:** ✅ Completed

## Objective
Deploy the crashing-app to Kubernetes and understand the difference between Pod and Deployment.

---

## Step 1: Create Pod YAML

Created a simple Pod manifest:

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
```

| Field | Description |
|-------|-------------|
| `apiVersion: v1` | Core API version for Pod resource |
| `kind: Pod` | Resource type |
| `metadata.name` | Unique name for this pod |
| `metadata.labels` | Labels for organizing and selecting pods |
| `spec.containers` | List of containers in the pod |
| `image` | Docker image to use (loaded from Minikube) |
| `containerPort` | Port exposed by the container |

---

## Step 2: Deploy Pod to Kubernetes

### Apply Command

```bash
kubectl apply -f pod.yaml
```

### Output

```
pod/crashing-app-pod created
```

---

## Step 3: Verify Pod Status

### Check Pods Command

```bash
kubectl get pods
```

### Output

```
NAME               READY   STATUS    RESTARTS   AGE
crashing-app-pod   1/1     Running   0          11s
```

| Column | Value | Meaning |
|--------|-------|---------|
| NAME | crashing-app-pod | Pod name as defined in YAML |
| READY | 1/1 | 1 container ready out of 1 |
| STATUS | Running | Pod is running successfully |
| RESTARTS | 0 | No restarts occurred |
| AGE | 11s | Pod has been running for 11 seconds |

✅ Pod deployed successfully and is running.

---

## Step 4: View Pod Logs

### Logs Command

```bash
kubectl logs crashing-app-pod
```

### Output

```
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:8080
 * Running on http://10.244.0.5:8080
Press CTRL+C to quit
```

| Log Entry | Meaning |
|-----------|---------|
| `Serving Flask app 'app'` | Flask application started successfully |
| `Debug mode: off` | Running in production mode |
| `Running on all addresses (0.0.0.0)` | Listening on all network interfaces |
| `Running on http://10.244.0.5:8080` | Pod's internal cluster IP address |

✅ Application is running inside the pod and ready to accept requests.

---

## Step 5: Delete the Pod

### Delete Command

```bash
kubectl delete pod crashing-app-pod
```

### Output

```
pod "crashing-app-pod" deleted
```

> ⏱️ The deletion took a few seconds to complete.

### Verify Deletion

```bash
kubectl get pods
```

### Output

```
No resources found in default namespace.
```

⚠️ **Key Observation:** When a Pod is deleted, it's gone forever. There's no automatic recovery or recreation. This is a critical limitation of using standalone Pods.

---
