FROM php:5-apache

RUN apt-get update && apt-get install -y \
    php5-mysql \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
  && docker-php-ext-install mysql mysqli pdo pdo_mysql opcache mbstring \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && a2enmod rewrite
  
# Use our php and apache config files
COPY config/php.ini /usr/local/etc/php/
COPY config/apache2.conf /etc/apache2/apache2.conf

# Copy Drupal into the webroot
COPY src/ /var/www/html/

VOLUME ["/var/www/html"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
