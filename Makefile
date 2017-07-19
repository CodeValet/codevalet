

all: containers

containers:
	$(MAKE) -C docker

.PHONY: clean all containers
