# Utilisez l'image officielle PHP avec Apache
FROM php:7.4-apache

# Installez les dépendances nécessaires
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Copiez les fichiers de votre projet
COPY . /var/www/html/

# Configurez les permissions appropriées
RUN chown -R www-data:www-data /var/www/html/

# Exposez le port (80 est standard pour Apache)
EXPOSE 80

# Commande pour lancer Apache en mode foreground
CMD ["apache2-foreground"]
