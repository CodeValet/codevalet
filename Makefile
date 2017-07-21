IMAGE_PREFIX="rtyler/codevalet"

all: plugins master

plugins: ./scripts/build-plugins builder
	./scripts/build-plugins

builder: Dockerfile.builder
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .

master: Dockerfile.master build/git-refs.txt
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .

build/git-refs.txt:
	./scripts/record-sha1sums

plan: validate
	./scripts/terraform plan --var-file=.terraform.json plans

validate: plans/*.tf
	./scripts/terraform validate plans

deploy: plan
	./scripts/terraform apply --var-file=.terraform.json plans


clean:
	rm -f build/git-refs.txt

.PHONY: clean all plugins master builder plan validate deploy
