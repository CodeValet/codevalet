IMAGE_PREFIX="rtyler/codevalet"


check: container

container: Dockerfile
	docker build -t ${IMAGE_PREFIX}-proxy .

.PHONY: clean check container
