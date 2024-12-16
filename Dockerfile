FROM php:8.3-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy custom Nginx configuration from the `nginx/` directory
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy application files from the `html/` directory
COPY ./html /var/www/html

# Configure permissions for the application files
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Install Supervisor to manage both Nginx and PHP-FPM
RUN apt-get update && apt-get install -y supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start Supervisor
CMD ["supervisord", "-n"]
