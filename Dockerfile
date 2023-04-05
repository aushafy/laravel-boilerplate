FROM php:8.0.28-apache-buster

# do update and install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt update -y && apt install gnupg2 ca-certificates apt-transport-https  software-properties-common nodejs unzip wget -y

# get php mysql dependency library
RUN docker-php-ext-install pdo_mysql mysqli

# install composer
RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# main workdir
WORKDIR /var/www/html

# copy source code
COPY . .

# rename .env.example to .env
RUN mv .env.example .env

RUN chmod -R 777 /var/www/html

RUN composer install
RUN npm install
RUN php artisan key:generate
RUN php artisan migrate
RUN php artisan db:seed
RUN php artisan storage:link
RUN npm run development