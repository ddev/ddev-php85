#ddev-generated
ARG BASE_IMAGE
FROM $BASE_IMAGE
ARG username=www-data
ARG uid=33
ARG gid=33

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo "PATH=${PATH}:/var/www/html/vendor/bin" >> /etc/skel/.profile

RUN echo "username=${username} uid=${uid} gid=${gid}"
RUN groupadd --gid $gid "$username" || groupadd "$username" || true
RUN useradd -G tty -l -m -s "/bin/bash" --gid "$username" --comment '' --uid $uid "$username" || useradd -G tty -l -m -s "/bin/bash" --gid "$username" --comment '' "$username" || useradd  -G tty -l -m -s "/bin/bash" --gid "$gid" --comment '' "$username" || useradd -G tty -l -m -s "/bin/bash" --comment '' $username

RUN apt-get update && apt-get install -y curl gnupg ca-certificates \
    && rm -rf /var/lib/apt/lists/*


# Install system dependencies that are always needed
RUN apt-get update && apt-get install -y \
    git \
    default-mysql-client \
    procps \
    sudo \
    unzip \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "[client]\nssl=0" > /etc/mysql/mariadb.conf.d/disable-ssl.cnf

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

RUN echo "ALL ALL=NOPASSWD: ALL" >> /etc/sudoers.d/ddev && chmod 440 /etc/sudoers.d/ddev

RUN cat >/home/${username}/.my.cnf <<'EOC'
[client]
ssl=0
user=root
password=root
host=db
default-character-set = utf8mb4
[mysql]
database=db
pager=
EOC

RUN chown ${uid}:${gid} /home/${username}/.my.cnf && chmod 600 /home/${username}/.my.cnf

# Try to get drush to respect --skip-ssl (failed)
RUN mkdir -p /etc/drush
RUN cat <<'EOF' > /etc/drush/drush.yml
options:
  sql-cli:
    extra: "--skip-ssl"
EOF

# Set working directory
WORKDIR /var/www/html