#ddev-generated
ARG BASE_IMAGE
FROM $BASE_IMAGE

# Install system dependencies and PHP extensions that are commonly needed
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libmagickwand-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        curl \
        dom \
        fileinfo \
        gd \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        simplexml \
        xml \
        zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure PHP
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/docker-php-memory-limit.ini
RUN echo "upload_max_filesize = 50M" > /usr/local/etc/php/conf.d/docker-php-upload-limit.ini
RUN echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/docker-php-upload-limit.ini

# Set working directory
WORKDIR /var/www/html