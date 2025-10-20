#!/usr/bin/env bash

rm -rf ./docs
docker run -v "${PWD}/site:/site" -w /site wayback-downloader 'http://secretgardens.com' --all-timestamps
mkdir -p ./docs && cp -a site/websites/secretgardens.com/* ./docs
echo -n 'secretgardens.ryanjarv.sh' > docs/CNAME
