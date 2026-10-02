#!/bin/sh
set -e

# Bootstrap the application only when starting PHP-FPM (the "app" service).
# Any other command (queue, artisan, composer...) runs as is.
if [ "$1" = "php-fpm" ]; then
    if [ ! -f .env ]; then
        echo "Arquivo .env não encontrado. Crie-o com: cp .env.dev .env" >&2
        exit 1
    fi

    composer install --no-interaction --prefer-dist --no-progress

    if ! grep -qE '^APP_KEY=.+' .env; then
        php artisan key:generate --ansi
    fi

    php artisan migrate --force
fi

exec "$@"
