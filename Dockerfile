ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fmp-alpine # Usamos -cli ya que artisan serve es un comando CLI

# Instalar dependencias del sistema:
# - libpq-dev: para compilar la extensión pdo_pgsql en Debian
# - build-essential, autoconf: herramientas de compilación
# - zip, unzip, git, curl: utilidades comunes
# - libxml2-dev, libonig-dev: para xml y mbstring respectivamente
RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    autoconf \
    zip \
    unzip \
    git \
    curl \
    libxml2-dev \
    libonig-dev \
    # Limpiar caché de apt para reducir tamaño
 && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP esenciales
RUN docker-php-ext-install -j$(nproc) pdo pdo_pgsql mbstring tokenizer xml

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-interaction --no-dev --optimize-autoloader --no-scripts

COPY . .

EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]