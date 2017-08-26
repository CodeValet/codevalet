IMAGE="rtyler/codevalet-proxy"

check: container
	docker run --rm -ti $(IMAGE) nginx -t

container: Dockerfile
	docker build -t $(IMAGE) .

.PHONY: clean check container
