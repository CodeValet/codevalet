IMAGE=rtyler/codevalet-proxy

check: container
	docker run --rm \
		-e JENKINS_CODEVALET_SERVICE_HOST=127.0.1.1 \
		-e JENKINS_CODEVALET_SERVICE_PORT=80 \
		-e JENKINS_FOOBAR_SERVICE_HOST=127.0.2.1 \
		-e JENKINS_FOOBAR_SERVICE_PORT=80 \
		$(IMAGE):latest /usr/bin/run-nginx test

container: Dockerfile
	docker build -t $(IMAGE) .

.PHONY: clean check container
