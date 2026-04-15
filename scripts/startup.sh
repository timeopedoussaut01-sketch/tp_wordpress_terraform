#!/bin/bash
apt-get update
apt-get install -y apache2
echo "Hello de la part de Terraform sur GCP !" > /var/www/html/index.html
