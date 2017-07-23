IMAGE_PREFIX="rtyler/codevalet"

check: generate plans validate
	$(MAKE) -C webapp check

all: plugins master

plugins: ./scripts/build-plugins plugins.txt builder
	./scripts/build-plugins

builder: Dockerfile.builder
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .

master: Dockerfile.master build/git-refs.txt
	docker build -t ${IMAGE_PREFIX}-$@ -f Dockerfile.$@ .

build/git-refs.txt:
	./scripts/record-sha1sums

validate: plans/*.tf generate-tfs
	./scripts/terraform validate plans

plan: validate
	./scripts/terraform plan --var-file=.terraform.json plans

deploy: plan
	./scripts/terraform apply --var-file=.terraform.json plans

generate: generate-tfs generate-k8s

generate-tfs: monkeys.txt plans/generated
	@for m in $(shell cat monkeys.txt); do \
		echo ">> Generating Terraform resources for $$m" ; \
		cat plans/master.tf.template | sed "s/@@USER@@/$$m/" > plans/generated.$$m.tf ; \
	done;

generate-k8s: monkeys.txt k8s/generated
	@for m in $(shell cat monkeys.txt); do \
		echo ">> Generating kubernetes resources for $$m" ; \
		cat k8s/jenkins.yaml.template | sed "s/@@USER@@/$$m/" > k8s/generated/$$m.yaml ; \
	done;

deploy-k8s: .kube/config generate-k8s
	@for f in k8s/generated/*.yaml; do \
		echo ">> Provisioning resources from $$f"; \
		./scripts/kubectl create -f $$f  ; \
	done;

.kube/config:
	./scripts/az acs kubernetes get-credentials \
		-f ./.kube/config \
		-n codevaletdev-controlplane \
		-n codevaletdev-controlplane \
		-g codevaletdev-controlplane

k8s/generated:
	mkdir -p k8s/generated

webapp:
	$(MAKE) -C webapp

clean:
	rm -f build/git-refs.txt k8/generated
	$(MAKE) -C webapp clean

.PHONY: clean all plugins master builder plan validate \
	deploy generate-k8s deploy-k8s webapp check generate-tfs generate
