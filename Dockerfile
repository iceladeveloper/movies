ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-fpm-alpine

ARG UID=1000
ARG GID=1000

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer

RUN apk add --no-cache \
    bash \
    curl \
    git \
    supervisor \
    nginx \
    oniguruma-dev \
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    icu-dev \
    postgresql-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    pdo pdo_pgsql \
    mbstring \
    tokenizer \
    xml \
    bcmath \
    pcntl \
    exif \
    zip \
    intl \
    gd \
    opcache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN addgroup -g ${GID} --system laravel && \
    adduser -u ${UID} --system -G laravel -s /bin/sh laravel

WORKDIR /app

COPY --chown=laravel:laravel composer.json composer.lock ./
RUN composer install --no-interaction --no-plugins --no-scripts --no-dev --optimize-autoloader

COPY --chown=laravel:laravel . .

RUN chown -R laravel:laravel /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

RUN php artisan optimize:clear && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

USER laravel

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]