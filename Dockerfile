# Elige la versión de PHP que tu proyecto Laravel necesita.
# php:8.2-fpm-alpine es una buena base: PHP-FPM sobre Alpine Linux (ligero)
# Si solo vas a usar "php artisan serve" y no un servidor web completo como Nginx en este contenedor,
# podrías usar php:8.2-cli-alpine, pero fpm es más versátil si luego añades Nginx.
ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm-alpine

# Argumentos para el usuario y grupo (opcional, pero buena práctica)
ARG UID=1000
ARG GID=1000

# Variables de entorno
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer

# Instalar dependencias del sistema necesarias para Laravel y extensiones de PHP
# - postgresql-dev es para la extensión pdo_pgsql
# - icu-dev es para la extensión intl
# - libzip-dev para zip
# - libpng-dev, libjpeg-turbo-dev, freetype-dev para gd
RUN apk add --no-cache \
    bash \
    curl \
    git \
    supervisor \
    nginx \
    oniguruma-dev \ # Dependencia de mbstring en Alpine
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    icu-dev \
    postgresql-dev \ # Para pdo_pgsql
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
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

# Instalar Composer globalmente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear usuario y grupo de la aplicación (opcional, pero mejora la seguridad)
RUN addgroup -g ${GID} --system laravel && \
    adduser -u ${UID} --system -G laravel -s /bin/sh laravel

WORKDIR /app

# Copiar primero composer.json y composer.lock para aprovechar el caché de Docker
COPY --chown=laravel:laravel composer.json composer.lock ./
# Instalar dependencias de Composer sin scripts de dev y optimizar autoloader
RUN composer install --no-interaction --no-plugins --no-scripts --no-dev --optimize-autoloader

# Copiar el resto de la aplicación
COPY --chown=laravel:laravel . .

# Establecer permisos correctos para Laravel
RUN chown -R laravel:laravel /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Optimizar Laravel para producción
# No es estrictamente necesario ejecutar esto en el build si tus entrypoint lo hace,
# pero puede ser útil para asegurar que la imagen está lista.
RUN php artisan optimize:clear && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Cambiar al usuario no root
USER laravel

# Exponer el puerto que Laravel usará
EXPOSE 8000

# Comando por defecto para iniciar la aplicación
# Esto usa el servidor de desarrollo de Artisan, que es bueno para desarrollo/pruebas.
# Para producción, normalmente usarías PHP-FPM con Nginx/Apache.
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]