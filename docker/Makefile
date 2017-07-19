IMAGE_PREFIX="rtyler/codevalet"

all: builder master

builder: Dockerfile.builder
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .

master: Dockerfile.master
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .


.PHONY: clean all builder master
