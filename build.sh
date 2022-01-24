#!/bin/bash
docker build -t alymab/php-fpm-oci8:latest --squash --compress --force-rm -f Dockerfile .  && \
[[ $1 == '--push' ]] && docker push alymab/php-fpm-oci8:latest