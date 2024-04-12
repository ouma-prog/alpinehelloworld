# Utilisez l'image de base officielle PHP avec Apache
FROM php:7.4-apache

# Installez les packages nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    graphviz \
    && a2enmod rewrite \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring zip exif pcntl xml

# Copiez les fichiers du projet dans le répertoire /var/www/html
COPY . /var/www/html/

# Donnez la propriété des fichiers au serveur web
RUN chown -R www-data:www-data /var/www/html

# Exposez le port 80
EXPOSE 80

# Utilisez le script par défaut pour démarrer Apache
CMD ["apache2-foreground"]
