#!/usr/bin/env bash

mkdir -p var
mkdir -p generated
mkdir -p vendor
mkdir -p pub/static
mkdir -p pub/media
mkdir -p app/etc

find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \;
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} \;
chgrp -R www-data .
chmod u+x bin/magento