FROM php:7.1-apache

#------------------------
# Packages
#------------------------
RUN apt-get update && apt-get install -y \
    libjpeg62-turbo-dev \
    libpng-dev \
    unzip \
    git \
    mysql-client \
    netcat

#------------------------
# Composer
#------------------------
RUN curl -s http://getcomposer.org/installer | php \
 && echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc \
 && mv composer.phar /usr/local/bin/composer

#------------------------
# PHP Extensions
#------------------------
RUN docker-php-ext-install \
    pdo pdo_mysql \
    opcache

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install gd

#------------------------
# Xdebug Extensions
#------------------------
RUN yes | pecl install xdebug \
 && docker-php-ext-enable xdebug

#------------------------
# Apache configuration
#------------------------
RUN a2enmod rewrite
RUN service apache2 restart

#------------------------
# Bash config
#------------------------
RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git /.bash_it \
&& /.bash_it/install.sh

RUN rm -rf /tmp/*

# Configure entrypoint
COPY ./drupal-entrypoint.sh /
RUN ["chmod", "+x", "/drupal-entrypoint.sh"]

WORKDIR /var/www/html

ENTRYPOINT ["/drupal-entrypoint.sh"]
