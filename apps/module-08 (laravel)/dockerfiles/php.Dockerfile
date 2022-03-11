FROM php:fpm-alpine
WORKDIR /var/www/html
COPY src .

RUN docker-php-ext-install pdo pdo_mysql