
check: depends container

all: depends

depends: Gemfile
	./scripts/ruby bundle install

run: depends
	./scripts/ruby bundle exec rackup -o 0.0.0.0

container: depends Dockerfile
	docker build -t rtyler/codevalet-webapp .

clean:
	rm -rf vendor

.PHONY: all depends clean run check container
