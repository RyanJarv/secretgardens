#!/usr/bin/env bash

docker run -v "${PWD}/site:/site" -w /site wayback-downloader 'http://secretgardens.com' --from 20000207045252 --to 20260207045252
cp -a site/websites/secretgardens.com/* ./docs/
echo -n 'secretgardens.ryanjarv.sh' > docs/CNAME
