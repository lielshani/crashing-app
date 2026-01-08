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
