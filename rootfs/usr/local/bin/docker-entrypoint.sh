#!/bin/sh

set -e

case "${1:-}" in
    "laravel")
        apache2-foreground
        ;;
    "laravel-scheduler")
        while sleep 60 ; do
            /usr/local/bin/php /var/www/app/artisan schedule:run
        done
        ;;
    "laravel-worker")
        exec /usr/local/bin/php /var/www/app/artisan queue:work
        ;;
    "/bin/sh" | "sh" | "/bin/bash" | "bash" )
        exec "$@"
        ;;
    *)
        echo "Usage: ${0} {laravel|laravel-scheduler|laravel-worker|bash|sh}" >&2
        exit 3
        ;;
esac
