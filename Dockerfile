FROM php:8.1-fpm-alpine as php
 
RUN apk add --no-cache \
	acl \
	fcgi \
	file \
	gettext \
	git \
	grep \
	mysql-client \
	bzip2-dev \
	libzip-dev \
	zip \
	libpng-dev \
	;
 
RUN docker-php-ext-install bz2
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install exif
 
RUN apk add --no-cache ${PHPIZE_DEPS} imagemagick imagemagick-dev
RUN pecl install -o -f imagick\
    &&  docker-php-ext-enable imagick
 
RUN apk del --no-cache ${PHPIZE_DEPS}
 
# Get latest Composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
 
WORKDIR /srv/api/admin
ARG APP_ENV=prod
 
COPY /  ./
 
RUN set -eux; \
	php -d memory_limit=-1 /usr/bin/composer install --no-dev --prefer-dist --no-scripts --no-progress --no-suggest; \
	composer clear-cache
 
 
COPY .env.example ./.env
 
COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
 
ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]