FROM php:8.1-fpm

ARG user
ARG uid

# install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    vim 

# clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install php extension
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# get latest Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# create user system to run composer and artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# setup working directory
WORKDIR /var/www/

USER $user