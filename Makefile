IMAGE_PREFIX="rtyler/codevalet"

all: plugins master

plugins: ./scripts/build-plugins builder
	./scripts/build-plugins

builder: Dockerfile.builder
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .

master: Dockerfile.master
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .


.PHONY: clean all plugins master builder
