FROM php:8.1-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /var/www/html

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk update && apk add --no-cache \
    libpng-dev \
    jpeg-dev \
    freetype-dev \
    zip \
    unzip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN composer install

EXPOSE 9000
CMD php artisan serve --host=0.0.0.0 --port=9000