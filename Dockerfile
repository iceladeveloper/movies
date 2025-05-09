FROM php:8.1
# O php:8.2, php:8.3 si prefieres y tu código es compatible

# Instalar dependencias del sistema, herramientas de compilación y librerías -dev para extensiones PHP
RUN apt-get update -y && apt-get install -y \
    openssl \
    zip \
    unzip \
    git \
    # Herramientas de compilación necesarias para docker-php-ext-install
    build-essential \
    autoconf \
    # Dependencia para la extensión mbstring
    libonig-dev \
    # Limpiar la caché de apt para reducir el tamaño de la imagen
 && rm -rf /var/lib/apt/lists/*

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar extensiones PHP
RUN docker-php-ext-install pdo mbstring

WORKDIR /app

# Copiar primero composer.json y composer.lock para aprovechar el caché de Docker
COPY composer.json composer.lock ./

# Instalar dependencias de Composer
# Ahora debería funcionar con PHP 8.1+
RUN composer install --no-interaction --no-plugins --no-scripts --no-dev --optimize-autoloader

# Copiar el resto de la aplicación
COPY . .

# Exponer el puerto
EXPOSE 8181

# Comando por defecto para ejecutar la aplicación
CMD php artisan serve --host=0.0.0.0 --port=8181