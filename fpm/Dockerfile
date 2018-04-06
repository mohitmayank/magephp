FROM php:7.0-fpm

MAINTAINER Mohit Jain <mail@jainmohit.com>

RUN apt-get update && apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng12-dev \
	g++ \
	libicu-dev \
	libxml2-dev libxslt1-dev python-dev \
	&& docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include --with-jpeg-dir=/usr/include \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install pdo_mysql \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install mcrypt \
	&& docker-php-ext-install xsl \
	&& docker-php-ext-install soap \
	&& apt-get install -y --no-install-recommends git zip \
	&& curl --silent --show-error https://getcomposer.org/installer | php --install-dir=/usr/local/bin --filename=composer \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 9000
CMD ["php-fpm", "-F"]