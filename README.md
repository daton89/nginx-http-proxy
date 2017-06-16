# nginx-http-proxy


## Automate build of new Debian Server  

The process expected following steps: 

    - Configure UFW
    - Install nodejs mongodb and redis (optional)
    - With npm install bower and pm2

### configure ufw
```sh
# update debian package
sudo apt-get update
sudo apt-get upgrade -y
# install ufw
sudo apt-get install ufw
# restore default settings for incoming and outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing
# allow connections
sudo ufw allow ssh
sudo ufw allow www
# turn it on
sudo ufw enable
```

### install nodes  redis (optional) 
```sh
# update debian package
sudo apt-get update
sudo apt-get upgrade -y
#install curl
sudo apt-get install curl -y
#install nodejs 
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo bash -
sudo apt-get install -y nodejs
```

### install mongodb
```sh
# import public key 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# Create a /etc/apt/sources.list.d/mongodb-org-3.2.list file for MongoDB
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.4.5 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.5.list
# Reload local package database
sudo apt-get update
# Install the MongoDB packages
sudo apt-get install -y mongodb-org
# Start MongoDB
sudo systemctl start mongod
# Enable startup MongoDb on boot
sudo systemctl enable mongod
```

### with npm install bower pm2 
```sh
# Install Git (it's required for bower)
sudo apt-get install -y git-core

# Install pm2
sudo npm i -g pm2
```


## Set Up Nginx Server Blocks 

```sh
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

```