#ddev-generated
ARG BASE_IMAGE
FROM $BASE_IMAGE

# Install system dependencies that are always needed
RUN apt-get update && apt-get install -y \
    git \
    mariadb-client \
    procps \
    sudo \
    unzip \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions using the modern install-php-extensions script
# This automatically handles dependencies and is the current recommended approach
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
        apcu \
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
        zip

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure PHP
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/docker-php-memory-limit.ini
RUN echo "upload_max_filesize = 50M" > /usr/local/etc/php/conf.d/docker-php-upload-limit.ini
RUN echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/docker-php-upload-limit.ini

RUN echo 'ALL ALL=NOPASSWD: ALL \
          Defaults env_keep += "*_proxy *_PROXY DDEV_* IS_DDEV_PROJECT PHP_DEFAULT_VERSION"' >/etc/sudoers.d/ddev

# Set working directory
WORKDIR /var/www/html