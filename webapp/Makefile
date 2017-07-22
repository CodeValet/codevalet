
all: depends

depends: Gemfile
	./scripts/ruby bundle install

run: depends
	./scripts/ruby bundle exec rackup -o 0.0.0.0

clean:
	rm -rf vendor

.PHONY: all depends clean run
