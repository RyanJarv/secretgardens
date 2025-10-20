build:
	@docker build -t wayback-downloader .

update: build clean
	./scripts/fetch.sh
