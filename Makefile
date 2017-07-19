

all: master

builder:
	$(MAKE) -C docker builder

master:
	$(MAKE) -C docker master

plugins: ./scripts/build-plugins master
	./scripts/build-plugins


.PHONY: clean all plugins master builder
