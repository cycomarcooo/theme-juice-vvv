#!/bin/bash

# Make sure these directories exist
mkdir -p "/etc/php/5.6/apache2/conf.d/"

# Copy php configuration from local
rsync -rvzh "/srv/config/php5-config/php-custom.ini" "/etc/php/5.6/apache2/conf.d/00-php-custom.ini"
rsync -rvzh "/srv/config/php5-config/opcache.ini" "/etc/php/5.6/apache2/conf.d/99-opcache.ini"
rsync -rvzh "/srv/config/php5-config/xdebug.ini" "/etc/php/5.6/apache2/conf.d/99-xdebug.ini"

# # Find the path to Xdebug and prepend it to xdebug.ini
# XDEBUG_PATH=$(find /usr -name 'xdebug.so' | head -1)
# sed -i "1izend_extension=\"$XDEBUG_PATH\"" "/etc/php/5.6/mods-available/xdebug.ini"

echo " * /srv/config/php5-config/php-custom.ini -> /etc/php/5.6/apache2/conf.d/00-php-custom.ini"
echo " * /srv/config/php5-config/opcache.ini -> /etc/php/5.6/apache2/conf.d/99-opcache.ini"
echo " * /srv/config/php5-config/xdebug.ini -> /etc/php/5.6/apache2/conf.d/99-xdebug.ini"

# Copy memcached configuration from local
rsync -rvzh "/srv/config/memcached-config/memcached.conf" "/etc/memcached.conf"
echo " * /srv/config/memcached-config/memcached.conf -> /etc/memcached.conf"

apt_package_install_list=()

apt_package_check_list=(
  # Our base packages for php5

  php5.6
  php5.6-cli

  # Common and dev packages for php
  php5.6-common
  php5.6-dev

  # Extra PHP modules that we find useful
  php-memcache
  php-imagick
  php-xdebug
  php5.6-mcrypt
  php5.6-mysql
  php5.6-imap
  php5.6-curl
  php5.6-mbstring

  # php5.6-pear
  php5.6-gd
  openssl
  # php5.6-apc
  php5.6-cgi

  apache2-mpm-worker
)

# Loop through each of our packages that should be installed on the system. If
# not yet installed, it should be added to the array of packages to install.
for pkg in "${apt_package_check_list[@]}"; do
  package_version=$(dpkg -s "${pkg}" 2>&1 | grep 'Version:' | cut -d " " -f 2)
  if [[ -n "${package_version}" ]]; then
    space_count="$(expr 20 - "${#pkg}")" #11
    pack_space_count="$(expr 30 - "${#package_version}")"
    real_space="$(expr ${space_count} + ${pack_space_count} + ${#package_version})"
    printf " * $pkg %${real_space}.${#package_version}s ${package_version}\n"
  else
    echo " *" $pkg [not installed]
    apt_package_install_list+=($pkg)
  fi
done

if [[ ${#apt_package_install_list[@]} = 0 ]]; then
  echo -e "No apt packages to install.\n"
else
  LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php

  # Update all of the package references before installing anything
  echo "Running apt-get update..."
  apt-get update -y

  # Install required packages
  echo "Installing apt-get packages..."
  apt-get install -y ${apt_package_install_list[@]}

  # Clean up apt caches
  apt-get clean
fi

# Disable non thread safe modules
a2dismod php5 php5.6 mpm_prefork
a2enmod mpm_worker

service apache2 restart
