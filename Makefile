build:
	@docker build -t wayback-downloader .

fetch: build
	@docker run -v "$(pwd)/site:/site" -w /site wayback-downloader 'http://secretgardens.com' --from 20240229214702 --to 20250207045252
