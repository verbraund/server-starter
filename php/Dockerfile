ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    zip \
    curl \
    wget \
    unzip \
    locales \
    libzip-dev \
    libonig-dev \
    libpng-dev \
    libxml2-dev \
    libpq-dev

RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install -o -f redis &&  rm -rf /tmp/pear
RUN docker-php-ext-enable redis
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install iconv
RUN docker-php-ext-install gd
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install xml
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pgsql
RUN docker-php-ext-configure zip && docker-php-ext-install zip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www
CMD ["php-fpm"]
