build:
    docker build -t wayback-downloader .

fetch: build
    docker run -v "$(pwd)/site:/site" -w /site wayback-downloader 'http://secretgardens.com' -t 20240807175123
