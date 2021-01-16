FROM composer:2 AS Composer
FROM php:7.4-apache AS Release

# Composer settings
ENV COMPOSER_HOME /usr/local/lib/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_CACHE_DIR /dev/null

# Install composer
COPY --from=Composer /usr/bin/composer /usr/bin/composer
COPY --from=Composer /tmp/keys.dev.pub /tmp/keys.tags.pub ${COMPOSER_HOME}/

# Install OS Packages
RUN apt update \
    && apt upgrade --yes \
    && apt install --yes --no-install-recommends \
        # for composer
        unzip \
        # for laravel-scheduler
        cron \
        # for pgsql php extension
        libpq5 libpq-dev \
        # for gd php extension
        libgd-dev \
        # for xsl php extension
        libxslt1-dev \
        # for zip php extension
        libzip-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install PHP Extensions
RUN pecl install \
        redis \
    && docker-php-ext-install \
        calendar exif gd gettext pcntl pdo_pgsql pgsql shmop sockets sysvmsg sysvsem sysvshm xsl opcache zip \
    && docker-php-ext-enable \
        opcache redis

# Copy middleware config files
COPY rootfs/ /

WORKDIR /var/www/app

# Copy all source files to /var/www/app for production.
# But available to overwrite by volume option when development.
COPY . .

RUN chown -R root:www-data storage && chmod -R 775 storage

# Install Composer packages without development package
RUN composer install --no-dev

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["laravel"]

FROM Release AS Develop

# Install Composer packages with development package
RUN composer install --dev
