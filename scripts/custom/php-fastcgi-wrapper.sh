# php-fastcgi-wrapper
#
# Install fastcgi wrapper
if [[ ! -f "/usr/local/bin/php-fastcgi-wrapper" ]]; then
  echo "Installing php-fastcgi-wrapper..."
  cat > /usr/local/bin/php-fastcgi-wrapper <<'EOT'
#!/bin/sh
# Set desired PHP_FCGI_* environment variables.
# Example:
# PHP FastCGI processes exit after 500 requests by default.
PHP_FCGI_MAX_REQUESTS=10000
export PHP_FCGI_MAX_REQUESTS

PHP_FCGI_CHILDREN=5
export PHP_FCGI_CHILDREN

# Replace with the path to your FastCGI-enabled PHP executable
#exec /usr/bin/php-cgi
exec /usr/bin/php-cgi5.6

EOT
  chown vagrant:www-data "/usr/local/bin/php-fastcgi-wrapper"
  chmod +x "/usr/local/bin/php-fastcgi-wrapper"
fi
