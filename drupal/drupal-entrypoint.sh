#!/bin/bash

set -e

# Await database.
while ! nc -q 1 db 3306 </dev/null; do sleep 3; done

echo ""
echo "--------------------------------------"
echo "--------- Database connected ---------"
echo "--------------------------------------"
echo ""

cd /var/www/html/
composer install

echo "export PATH=${PATH}:/var/www/html/vendor/drush/drush" >> ~/.bashrc

echo ""
echo "--------------------------------------"
echo "------ Dependencies Installed --------"
echo "--------------------------------------"
echo ""

# Configure Drupal, if not installed yet.
if [ ! -f /var/www/html/docroot/sites/default/settings.local.php ]
then

  # Copy configuration files.
  cp /var/www/html/drupal/settings/settings.php /var/www/html/docroot/sites/default/settings.php
  cp /var/www/html/drupal/settings/development.services.yml /var/www/html/docroot/sites/development.services.yml
  cp /var/www/html/drupal/settings/settings.local.php /var/www/html/docroot/sites/default/settings.local.php
  chmod -R 777 /var/www/html/docroot/sites/default/settings.local.php

  echo ""
  echo "-------- Database Variables ----------"
  echo ""
  echo "MYSQL_DATABASE: ${MYSQL_DATABASE}"
  echo ""
  echo "MYSQL_USER: ${MYSQL_USER}"
  echo ""
  echo "MYSQL_PASSWORD: ${MYSQL_PASSWORD}"
  echo ""
  echo "MYSQL_HOST: ${MYSQL_HOST}"
  echo ""
  echo "--------------------------------------"
  echo ""

  # Configure database connection based on docker-compose env variables.
  sed -i "s/{MYSQL_DATABASE}/${MYSQL_DATABASE}/g" /var/www/html/docroot/sites/default/settings.local.php
  sed -i "s/{MYSQL_USER}/${MYSQL_USER}/g" /var/www/html/docroot/sites/default/settings.local.php
  sed -i "s/{MYSQL_PASSWORD}/${MYSQL_PASSWORD}/g" /var/www/html/docroot/sites/default/settings.local.php
  sed -i "s/{MYSQL_HOST}/${MYSQL_HOST}/g" /var/www/html/docroot/sites/default/settings.local.php
fi

echo ""
echo "--------------------------------------"
echo "--------- Settings Ready -------------"
echo "--------------------------------------"
echo ""

# Creating files, if not exists.
if [ ! -d /var/www/html/docroot/sites/default/files ]
then

  # Create basic files and ensure permissions.
  mkdir -p /var/www/html/docroot/sites/default/files
  mkdir -p /var/www/html/docroot/sites/default/files/translations
fi

echo ""
echo "--------------------------------------"
echo "------------ Files Ready -------------"
echo "--------------------------------------"
echo ""

# Creating files, if not exists.
if [ ! -d /var/www/html/docroot/config ]
then

  # Create basic files and ensure permissions.
  mkdir -p /var/www/html/docroot/config
  mkdir -p /var/www/html/docroot/config/sync
fi

echo ""
echo "--------------------------------------"
echo "--------- Config Sync Ready ----------"
echo "--------------------------------------"
echo ""

# Ensure permissions are correct.
chmod -R 777 /var/www/html/docroot/sites/default/files
chmod -R 777 /var/www/html/docroot/config
chmod 777 /var/www/html/docroot/sites/default/settings.local.php
chmod +w -R /var/www/html/docroot/sites/default

echo ""
echo "------------------------------------"
echo "----- Container ready to work! -----"
echo "------------------------------------"
echo ""

# php:apache default entrypoint
apache2-foreground

exec "$@"
