ARG PHP_VERSION=8.1
FROM php:${PHP_VERSION}-cli-alpine # Usamos -cli ya que artisan serve es un comando CLI

# Instalar dependencias del sistema:
# - postgresql-dev: para compilar la extensión pdo_pgsql
# - build-base, autoconf: herramientas de compilación para extensiones PHP
# - zip, unzip: para Composer o dependencias de la aplicación
# - bash: útil para debugging o scripts
RUN apk add --no-cache \
    bash \
    postgresql-dev \
    zip \
    unzip \
    --virtual .build-deps \
    build-base \
    autoconf

# Instalar extensiones PHP esenciales para Laravel y PostgreSQL:
# - pdo, pdo_pgsql: para la conexión a la base de datos
# - mbstring, tokenizer, xml: comunes y a menudo requeridas por Laravel y sus paquetes
RUN docker-php-ext-install -j$(nproc) pdo pdo_pgsql mbstring tokenizer xml

# Limpiar dependencias de compilación para reducir el tamaño de la imagen
RUN apk del .build-deps

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copiar composer.json y composer.lock primero para aprovechar el caché de Docker
COPY composer.json composer.lock ./

# Instalar dependencias de Composer
# --no-scripts puede omitir scripts de composer que podrían no ser necesarios para un CRUD simple
# o que podrían requerir más dependencias. Si los necesitas, quita --no-scripts.
RUN composer install --no-interaction --no-dev --optimize-autoloader --no-scripts

# Copiar el resto de la aplicación
COPY . .

# Puerto estándar para php artisan serve
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]