TF_VARFILE=.terraform.cb.json
TERRAFORM=./scripts/terraform

check: generate validate
	$(MAKE) -C webapp check

generate: generate-k8s

run: webapp
	docker-compose up

clean:
	rm -rf k8s/generated
	docker-compose down || true
	$(MAKE) -C webapp clean



## Handle sub-projects
###############################################################
webapp:
	$(MAKE) -C webapp
###############################################################


## Terraform
###############################################################
validate: plans/*.tf tfinit
	$(TERRAFORM) validate --var-file=$(TF_VARFILE) plans

plan: validate tfinit
	$(TERRAFORM) plan --var-file=$(TF_VARFILE) plans

deploy: plan tfinit
	$(TERRAFORM) apply --var-file=$(TF_VARFILE) plans

tfinit: $(TF_VARFILE) ./scripts/tf-init
	./scripts/tf-init $(TF_VARFILE)
$(TF_VARFILE):
	touch $(TF_VARFILE)
###############################################################


## Kubernetes
###############################################################
generate-k8s: monkeys.txt k8s/generated
	@for m in $(shell cat monkeys.txt); do \
		echo ">> Generating kubernetes resources for $$m" ; \
		cat k8s/jenkins.yaml.template | sed "s/@@USER@@/$$m/" > k8s/generated/$$m.yaml ; \
	done;

deploy-k8s: .kube/config generate-k8s
	@for f in k8s/*.yaml; do \
		echo ">> Provisioning resources from $$f"; \
		./scripts/kubectl create -f $$f || true ; \
	done;
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
###############################################################


.PHONY: clean all plan validate \
	deploy generate-k8s deploy-k8s webapp check generate \
	run tfinit
