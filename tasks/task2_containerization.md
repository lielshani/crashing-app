# Task 2: Containerization

**Status:** ✅ Completed

## Objective
Create a Docker container for the Flask application.

---

## Application Files

### 1. app.py

Created a simple Flask application with two endpoints:

```python
import os
from flask import Flask, jsonify

app = Flask(__name__)

app_mode = os.getenv("APP_MODE", "Production")
api_key = os.getenv("API_KEY", "MISSING")

@app.route("/")
def home():
    return jsonify({
        "status": "ok",
        "app_mode": app_mode,
        "api_key_present": api_key != "MISSING"
    })

@app.route("/crash")
def crash():
    raise RuntimeError("Intentional crash")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
```

| Endpoint | Description |
|----------|-------------|
| `/` | Returns JSON with app status and config info |
| `/crash` | Intentionally raises a RuntimeError |

### 2. Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]
```

| Instruction | Purpose |
|-------------|---------|
| `FROM python:3.12-slim` | Use lightweight Python 3.12 base image |
| `WORKDIR /app` | Set working directory inside container |
| `COPY requirements.txt .` | Copy dependencies file first (layer caching) |
| `RUN pip install` | Install Python dependencies |
| `COPY app.py .` | Copy application code |
| `EXPOSE 8080` | Document the exposed port |
| `CMD` | Define the startup command |

### 3. requirements.txt

```
flask==3.0.3
```

### 4. Makefile

Created a Makefile for convenient development workflow:

```makefile
IMAGE_NAME = crashing-app
IMAGE_TAG = 1.0
PORT = 8080

.PHONY: build run rebuild clean logs

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run:
	docker run -p $(PORT):$(PORT) $(IMAGE_NAME):$(IMAGE_TAG)

rebuild: build run

clean:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) 2>/dev/null || true

logs:
	docker logs $$(docker ps -q --filter ancestor=$(IMAGE_NAME):$(IMAGE_TAG))
```

| Command | Description |
|---------|-------------|
| `make build` | Build the Docker image |
| `make run` | Run the container |
| `make rebuild` | Build and run in one command |
| `make clean` | Remove the Docker image |
| `make logs` | View logs from running container |

---

## Build Docker Image

### Build Command

```bash
docker build -t crashing-app:1.0 .
```

### Build Output

```
[+] Building 9.4s (11/11) FINISHED                            docker:desktop-linux
 => [internal] load build definition from Dockerfile
 => [internal] load metadata for docker.io/library/python:3.12-slim
 => [auth] library/python:pull token for registry-1.docker.io
 => [internal] load .dockerignore
 => [internal] load build context
 => [1/5] FROM docker.io/library/python:3.12-slim@sha256:a75662dfec8d...
 => [2/5] WORKDIR /app
 => [3/5] COPY requirements.txt .
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt
 => [5/5] COPY app.py .
 => exporting to image
 => => naming to docker.io/library/crashing-app:1.0
```

### Image Details

| Property | Value |
|----------|-------|
| Image Name | crashing-app |
| Tag | 1.0 |
| Base Image | python:3.12-slim |
| Exposed Port | 8080 |

✅ Docker image built successfully and tagged as `crashing-app:1.0`.

---

## Load Image to Minikube

To use the Docker image in Minikube, load it into Minikube's internal registry:

```bash
minikube image load crashing-app:1.0
```

This makes the image available to Kubernetes deployments running in Minikube without needing to push it to an external registry.

### Verify Image Loaded

```bash
minikube image ls | grep crashing-app
```

Output:
```
docker.io/library/crashing-app:1.0
```

✅ Image successfully loaded into Minikube.
