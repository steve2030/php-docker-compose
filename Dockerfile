FROM php:7.4-fpm


# Set the working directory in the container
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    git \
    unzip \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip intl xml

# Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files to the container
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --no-scripts --prefer-dist

# Run Laravel artisan commands to optimize application
# RUN php artisan config:cache \
#     && php artisan route:cache \
#     && php artisan view:cache

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
