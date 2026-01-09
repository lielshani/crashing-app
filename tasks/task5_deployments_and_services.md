# Task 5: Deployments and Services

**Status:** ✅ Completed

## Objective
Deploy the crashing-app using a Kubernetes Deployment and demonstrate its self-healing capabilities.

---

## Step 1: Apply the Deployment

### Apply Command

```bash
kubectl apply -f deployment.yaml
```

### Output

```
deployment.apps/crashing-app created
```

---

## Step 2: Verify Pods Created by Deployment

### Check Pods Command

```bash
kubectl get pods
```

### Output

```
NAME                            READY   STATUS    RESTARTS   AGE
crashing-app-84fd6cff6f-s87fc   1/1     Running   0          33s
crashing-app-84fd6cff6f-scr2h   1/1     Running   0          33s
crashing-app-pod                1/1     Running   0          24m
```

| Pod | Description |
|-----|-------------|
| `crashing-app-84fd6cff6f-s87fc` | Deployment-managed pod (replica 1) |
| `crashing-app-84fd6cff6f-scr2h` | Deployment-managed pod (replica 2) |
| `crashing-app-pod` | Standalone pod from earlier (not managed by deployment) |

> 💡 **Note:** Deployment pods have a random suffix added to their names (e.g., `84fd6cff6f-s87fc`). This includes a ReplicaSet hash and a unique pod identifier.

---

## Step 3: Verify Deployment Status

### Check Deployments Command

```bash
kubectl get deployments
```

### Output

```
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
crashing-app   2/2     2            2           78s
```

| Column | Value | Meaning |
|--------|-------|---------|
| NAME | crashing-app | Deployment name as defined in YAML |
| READY | 2/2 | 2 pods ready out of 2 desired |
| UP-TO-DATE | 2 | 2 pods running the latest version |
| AVAILABLE | 2 | 2 pods available to serve traffic |
| AGE | 78s | Deployment has been running for 78 seconds |

✅ Deployment is running with 2 replicas as configured.

---

## Step 4: Demonstrate Self-Healing - Delete a Pod

### Delete One Deployment Pod

```bash
kubectl delete pod crashing-app-84fd6cff6f-s87fc
```

### Output

```
pod "crashing-app-84fd6cff6f-s87fc" deleted
```

---

## Step 5: Verify Self-Healing

### Check Pods After Deletion

```bash
kubectl get pods
```

### Output

```
NAME                            READY   STATUS    RESTARTS   AGE
crashing-app-84fd6cff6f-n9tqk   1/1     Running   0          43s
crashing-app-84fd6cff6f-scr2h   1/1     Running   0          2m28s
crashing-app-pod                1/1     Running   0          26m
```

| Observation | Details |
|-------------|---------|
| New pod created | `crashing-app-84fd6cff6f-n9tqk` (43s old) |
| Original pod gone | `crashing-app-84fd6cff6f-s87fc` no longer exists |
| Replica count maintained | Still 2 deployment pods running |

✅ **Self-Healing Demonstrated:** The Deployment automatically created a new pod to replace the deleted one, maintaining the desired replica count of 2.

---

## Key Takeaways

| Feature | Pod (Standalone) | Deployment |
|---------|------------------|------------|
| Self-healing | ❌ No | ✅ Yes |
| Replica management | ❌ No | ✅ Yes |
| Rolling updates | ❌ No | ✅ Yes |
| Automatic recreation | ❌ No | ✅ Yes |

> 🎯 **Conclusion:** Deployments provide resilience and high availability by automatically maintaining the desired number of pod replicas. When a pod fails or is deleted, the Deployment controller immediately creates a replacement.

---

## Step 6: Create a Service

Created a NodePort Service to expose the application:

### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: crashing-app-service
spec:
  type: NodePort
  selector:
    app: crashing-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30080
```

| Field | Description |
|-------|-------------|
| `type: NodePort` | Exposes the service on a static port on each node |
| `selector: app: crashing-app` | Routes traffic to pods with this label |
| `port: 80` | Service port (internal cluster access) |
| `targetPort: 8080` | Container port to forward traffic to |
| `nodePort: 30080` | External port on the node |

---

## Step 7: Apply the Service

### Apply Command

```bash
kubectl apply -f service.yaml
```

### Output

```
service/crashing-app-service created
```

---

## Step 8: Verify Service Status

### Check Services Command

```bash
kubectl get services
```

### Output

```
NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
crashing-app-service   NodePort    10.99.145.44   <none>        80:30080/TCP   39s
kubernetes             ClusterIP   10.96.0.1      <none>        443/TCP        26h
```

| Column | Value | Meaning |
|--------|-------|---------|
| TYPE | NodePort | Service is exposed on node ports |
| CLUSTER-IP | 10.99.145.44 | Internal cluster IP |
| EXTERNAL-IP | `<none>` | No external IP assigned |
| PORT(S) | 80:30080/TCP | Service port 80 mapped to NodePort 30080 |

---

## Step 9: Get Minikube IP

### Command

```bash
minikube ip
```

### Output

```
192.168.49.2
```

---

## Step 10: Verify Service Endpoints

Checked that the Service is properly connected to the Pods:

### Command

```bash
kubectl get endpoints crashing-app-service
```

### Output

```
NAME                   ENDPOINTS                           AGE
crashing-app-service   10.244.0.11:8080,10.244.0.13:8080   12m
```

✅ Service has 2 endpoints - correctly connected to both Deployment pods.

---

## Step 11: Access the Service via Minikube

### Command

```bash
minikube service crashing-app-service
```

> ⚠️ **Note:** On macOS with Docker driver, NodePort is not directly accessible via the minikube IP. The `minikube service` command creates a tunnel to access the service.

---
