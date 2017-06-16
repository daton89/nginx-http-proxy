#!/bin/bash

DOMAIN=$1

# Check update of package 
sudo apt-get update

# Install Nginx
sudo apt-get install -y nginx

# Step One — Set Up New Document Root Directories
sudo mkdir -p /var/www/$DOMAIN/html

# Transfer ownership to our current user
sudo chown -R $USER:$USER /var/www/$DOMAIN/html

# Make sure that permissions of our web roots are correct
sudo chmod -R 755 /var/www

# Step Two — Create Sample Pages for Each Site
cd /var/www/$DOMAIN/html/
touch index.html
echo "<html>" >> index.html 
echo "    <head>" >> index.html
echo "        <title>Welcome to $DOMAIN!</title>" >> index.html
echo "    </head>" >> index.html
echo "    <body>" >> index.html
echo "        <h1>Success!  The $DOMAIN server block is working!</h1>" >> index.html
echo "    </body>" >> index.html
echo "</html>" >> index.html

# Step Three — Create Server Block Files for Each Domain
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$DOMAIN
# remove default_server
sudo sed -i -e 's/listen 80 default_server;/listen 80;/g' /etc/nginx/sites-available/$DOMAIN
sudo sed -i -e 's/listen [::]:80 default_server;/listen [::]:80;/g' /etc/nginx/sites-available/$DOMAIN
# set domain root folder for this server block
sudo sed -i -e 's,root /var/www/html;,root /var/www/$DOMAIN/html;,g' /etc/nginx/sites-available/$DOMAIN
# set server_name to domain
sudo sed -i -e 's/server_name _/server_name $DOMAIN www.$DOMAIN/g' /etc/nginx/sites-available/$DOMAIN

# Step Four — Enable your Server Blocks and Restart Nginx
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

# remove default config Nginx form sites-enabled if it exists (it is available in sites-available) 
stat /etc/nginx/sites/enabled/default && sudo rm /etc/nginx/sites-enabled/default

# Reload Nginx if it works
sudo nginx -t && sudo service nginx reload
