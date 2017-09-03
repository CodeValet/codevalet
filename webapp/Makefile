
all: depends

check: depends container

depends: Gemfile
	./scripts/ruby bundle install

run: depends monkeys.txt
	./scripts/ruby bundle exec puma -o 0.0.0.0

container: depends Dockerfile monkeys.txt
	docker build -t rtyler/codevalet-webapp .

clean:
	rm -rf vendor

monkeys.txt: ../monkeys.txt
	cp ../monkeys.txt .

.PHONY: all depends clean run check container
