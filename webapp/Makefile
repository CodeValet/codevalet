
all: check container

check: spec check-container

depends: Gemfile
	./scripts/ruby bundle install

spec: depends
	./scripts/ruby bundle exec rspec -c

run: depends monkeys.txt
	./scripts/ruby bundle exec puma

check-container: container
	docker run --rm rtyler/codevalet-webapp:latest bundle exec puma --version

container: depends Dockerfile monkeys.txt
	docker build -t rtyler/codevalet-webapp .

clean:
	rm -rf vendor

monkeys.txt: ../monkeys.txt
	cp ../monkeys.txt .

.PHONY: all depends clean run check container spec check-container
