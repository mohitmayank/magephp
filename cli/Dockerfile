FROM php:7.0-cli

RUN apt-get update && apt-get install -y curl git subversion openssh-server openssl mercurial bash zlib1g-dev

RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
 && echo "date.timezone=${PHP_TIMEZONE:-UTC}" > "$PHP_INI_DIR/conf.d/date_timezone.ini"

RUN apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng12-dev \
	g++ \
	libicu-dev \
	libxml2-dev libxslt1-dev python-dev \
	mysql-client \
	&& docker-php-ext-configure gd --with-png-dir=/usr/include --with-jpeg-dir=/usr/include \
	&& docker-php-ext-install gd \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install mcrypt \
	&& docker-php-ext-install xsl \
	&& docker-php-ext-install soap \
	&& docker-php-ext-install zip \
	&& apt-get install -y --no-install-recommends git zip \
	&& curl --silent --show-error https://getcomposer.org/installer | php --install-dir=/usr/local/bin --filename=composer \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.6.3

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
 && php -r " \
    \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && rm -rf /tmp/* /tmp/.htaccess

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app
	
ARG MAGE_UID=1000
ARG MAGE_GID=1000
ARG MAGE_USER=mage

RUN mkdir -p /home/$MAGE_USER

RUN groupadd -g $MAGE_GID $MAGE_USER

RUN useradd -r -u $MAGE_UID -g $MAGE_USER $MAGE_USER

RUN chown -R  $MAGE_USER:$MAGE_USER /home/$MAGE_USER

RUN usermod -a -G www-data $MAGE_USER

RUN echo 'alias magerun="php bin/magento"' >> /home/$MAGE_USER/.bashrc
RUN echo 'alias mage-upgrade="php bin/magento setup:upgrade"' >> /home/$MAGE_USER/.bashrc
RUN echo 'alias mage-flush="php bin/magento cache:flush"' >> /home/$MAGE_USER/.bashrc
RUN echo 'alias mage-enable="php bin/magento module:enable"' >> /home/$MAGE_USER/.bashrc
RUN echo 'alias mage-disable="php bin/magento module:disable"' >> /home/$MAGE_USER/.bashrc
RUN echo 'alias mage-compile="php bin/magento setup:di:compile"' >> /home/$MAGE_USER/.bashrc

RUN echo 'alias ci="composer install"' >> /home/$MAGE_USER/.bashrc
RUN echo 'alias chmod-fix="/bin/permissions.sh"' >> /home/$MAGE_USER/.bashrc

RUN chmod +rx /home/$MAGE_USER/.bashrc

COPY permissions.sh /bin/permissions.sh

COPY clihelp.sh /bin/clihelp

RUN chmod +x /bin/permissions.sh

RUN chmod +x /bin/clihelp

USER $MAGE_USER

CMD ["bash"]
