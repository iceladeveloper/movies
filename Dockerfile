FROM php:8.1

# Instalar dependencias del sistema, herramientas de compilación y librerías -dev para extensiones PHP
RUN apt-get update -y && apt-get install -y \
    # Utilidades generales
    openssl \
    zip \
    unzip \
    git \
    curl \
    # Herramientas de compilación necesarias para docker-php-ext-install
    build-essential \
    autoconf \
    # Dependencias para extensiones PHP:
    libonig-dev \      # para mbstring
    libzip-dev \       # para zip
    zlib1g-dev \       # a menudo requerida por zip u otras
    libpng-dev \       # para gd
    libjpeg-dev \      # para gd
    libfreetype6-dev \ # para gd
    libicu-dev \       # para intl
    libpq-dev \        # para pdo_pgsql (si usas PostgreSQL)
    # default-libmysqlclient-dev # para pdo_mysql (si usas MySQL, descomenta)
 && rm -rf /var/lib/apt/lists/*

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar extensiones que lo necesiten (ej. GD)
# Asegúrate de que las opciones coincidan con las bibliotecas -dev instaladas
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) \
    pdo \
    # pdo_mysql \  # Descomenta si usas MySQL
    pdo_pgsql \  # Comenta si no usas PostgreSQL
    mbstring \
    tokenizer \
    xml \
    bcmath \
    pcntl \
    zip \
    intl \
    gd \
    opcache

WORKDIR /app

# Copiar primero composer.json y composer.lock para aprovechar el caché de Docker
COPY composer.json composer.lock ./

# Instalar dependencias de Composer
# Si esto sigue fallando, NECESITAMOS VER EL OUTPUT COMPLETO DE COMPOSER
RUN composer install --no-interaction --no-plugins --no-scripts --no-dev --optimize-autoloader

# Copiar el resto de la aplicación
COPY . .

# Exponer el puerto
EXPOSE 8181

# Comando por defecto para ejecutar la aplicación
CMD php artisan serve --host=0.0.0.0 --port=8181