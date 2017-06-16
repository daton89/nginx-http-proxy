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

# update debian package
sudo apt-get update
sudo apt-get upgrade -y
#install curl
sudo apt-get install -y curl
#install nodejs 
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo bash -
sudo apt-get install -y nodejs

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

# Install Git (it's required for bower)
sudo apt-get install -y git-core

# Install Bower and pm2
sudo npm i -g pm2