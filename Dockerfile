FROM php:7.3-apache

WORKDIR /var/www

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    nano \
    rsync \
    ssh \
    sudo \
    vim \
    wget \
    zsh \
    autoconf \
    g++ \
    libtool \
    make \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-install mysqli \
    && a2enmod rewrite \
    && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/default-ssl.conf \
    && mv /var/www/html /var/www/public \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=AT/ST=Vienna/L=Vienna/O=Security/OU=Development/CN=example.com" \
    && a2ensite default-ssl \
    && a2enmod ssl

COPY utils/xdebug.ini /tmp/xdebug.ini
ENV PHP_INI_DIR /usr/local/etc/php
RUN cp $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN echo 'memory_limit = 512M' >> $PHP_INI_DIR/php.ini
RUN echo 'error_log = /var/www/data/logs/errors.log' >> $PHP_INI_DIR/php.ini
RUN pecl install xdebug \
    && echo ";zend_extension=$(find / -iname xdebug.so)" >> $PHP_INI_DIR/php.ini \
    && cat /tmp/xdebug.ini >> $PHP_INI_DIR/php.ini
RUN sed -i "s/xdebug\.remote_host=.*/xdebug\.remote_host=$(getent hosts host.docker.internal | awk '{ print $1 }')/" $PHP_INI_DIR/php.ini
ENV PHP_IDE_CONFIG="serverName=01machinery"
ENV XDEBUG_CONFIG="idekey=PHPSTORM"

RUN mkdir /home/utente \
    && groupadd -g 1000 utente \
    && useradd -u 1000 --gid 1000 -d /home/utente -s /bin/bash utente \
    && usermod -a -G www-data utente \
    && chown utente /home/utente \
    && curl -sS https://getcomposer.org/installer | php --       --install-dir=/usr/local/bin --filename=composer       --version 1.8.5

RUN usermod -a -G sudo utente \
    && echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER utente

COPY utils/custom_xrc /home/utente
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && echo 'source ~/custom_xrc' >> /home/utente/.zshrc \
    && echo 'source ~/custom_xrc' >> /home/utente/.bashrc

USER root
