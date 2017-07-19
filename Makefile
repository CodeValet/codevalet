

all: master

builder:
	$(MAKE) -C docker builder

master: plugins
	$(MAKE) -C master

plugins: ./scripts/build-plugins master
	./scripts/build-plugins


.PHONY: clean all plugins master builder
