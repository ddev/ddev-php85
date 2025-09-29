#!/bin/bash
#ddev-generated

set -eu -o pipefail

# Replace DDEV's generated nginx-site.conf with our PHP 8.5 version
# This runs after DDEV has set up nginx config but before nginx starts

# Remove all existing nginx site configs to avoid conflicts
rm -f /etc/nginx/sites-enabled/*
# Copy our custom config that routes to PHP 8.5 container
cp /mnt/ddev_config/nginx_full/nginx-php85.conf /etc/nginx/sites-enabled/nginx-site.conf