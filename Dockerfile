FROM ghcr.io/herdphp/herd:latest

WORKDIR /app

COPY . /app

RUN composer install --no-dev --optimize-autoloader

RUN php artisan optimize:clear && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]