.PHONY: update build

build:
	@docker build -t wayback-downloader .

update: build
	./scripts/update.sh
