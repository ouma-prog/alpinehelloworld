# Utilisez une image de base PHP avec Apache
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

# Copiez les fichiers du projet dans le répertoire document root d'Apache
COPY . /var/www/html/

# Changez la propriété des fichiers pour l'utilisateur www-data
RUN chown -R www-data:www-data /var/www/html

# Exposez le port 80
EXPOSE 80

# Utilisez le script par défaut pour démarrer Apache en mode foreground
CMD ["apache2-foreground"]
