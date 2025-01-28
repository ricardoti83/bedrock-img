# Use a base image with PHP-FPM and Alpine Linux
FROM php:8.1-fpm-alpine

# Install necessary system dependencies, including Nginx
RUN apk add --no-cache \
    nginx \
    mysql-client \
    curl \
    git \
    unzip \
    bash \
    supervisor \
    tree

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

# Create necessary directories and copy the correct configuration
RUN mkdir -p /etc/nginx/conf.d

# Copy the main Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Set the working directory and copy project files into the container
WORKDIR /var/www
COPY . /var/www

# Set the correct file permissions
RUN chown -R www-data:www-data /var/www

# Expose port 80 for Nginx
EXPOSE 80

# Start PHP-FPM and Nginx in the same container
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
