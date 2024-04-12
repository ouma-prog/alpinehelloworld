Use a PHP and Apache base image
FROM php:7.4-apache

Install necessary packages (if any additional ones are needed)
RUN apt-get update && apt-get install -y \
    bash \
    && rm -rf /var/lib/apt/lists/*

Copy your project files into the Apache document root
COPY . /var/www/html/

Change ownership to www-data (Apache's user) for proper web server operation
RUN chown -R www-data:www-data /var/www/html

Create a user 'jostino' with no password and limited shell access
RUN adduser --disabled-password --gecos "" jostino

Change ownership of all files to 'jostino' for read access
RUN chown -R jostino:jostino /var/www/html

Modify permissions so that 'jostino' has read access only
RUN find /var/www/html -type d -exec chmod 755 {} ; && \
    find /var/www/html -type f -exec chmod 644 {} ;

Switch back to www-data user to run the application
USER www-data

Expose port 80 (default for Apache)
EXPOSE 80

Use the default Apache command to run
CMD ["apache2-foreground"]
