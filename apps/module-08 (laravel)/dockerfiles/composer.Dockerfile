FROM composer:latest

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs", "--ignore-platform-req", "--prefer-install"]