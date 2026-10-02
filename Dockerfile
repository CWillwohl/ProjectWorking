# syntax=docker/dockerfile:1

# Development image: the application code is not copied in,
# it is bind-mounted by docker-compose.yml.
ARG PHP_VERSION=8.2

FROM php:${PHP_VERSION}-fpm-alpine

# Match the host user so files created inside the container are owned by you
ARG UID=1000
ARG GID=1000

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:2 /usr/bin/install-php-extensions /usr/local/bin/

# fcgi is used by the PHP-FPM healthcheck, git/unzip by Composer
RUN apk add --no-cache fcgi git unzip \
    && install-php-extensions \
        bcmath \
        gd \
        intl \
        opcache \
        pcntl \
        pdo_mysql \
        redis \
        xdebug \
        zip

COPY docker/php/php.ini /usr/local/etc/php/conf.d/zz-app.ini
COPY docker/php/www.conf /usr/local/etc/php-fpm.d/zz-app.conf
COPY --chmod=755 docker/php/entrypoint.sh /usr/local/bin/entrypoint

RUN if ! getent group "${GID}" > /dev/null; then addgroup -g "${GID}" app; fi \
    && adduser -D -u "${UID}" -G "$(getent group "${GID}" | cut -d: -f1)" app

USER app

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]
