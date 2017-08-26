IMAGE="rtyler/codevalet-proxy"

check: container
	docker run --rm -ti $(IMAGE) /run-nginx test

container: Dockerfile
	docker build -t $(IMAGE) .

.PHONY: clean check container
