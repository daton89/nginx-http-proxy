# Set Up Nginx Server Blocks 

```sh
# Check update of package 
sudo apt-get update

# Install Nginx
sudo apt-get install nginx

# Step One — Set Up New Document Root Directories
sudo mkdir -p /var/www/jointloop.ovh/html
sudo mkdir -p /var/www/festivaldellastronomia.it/html

# Transfer ownership to our regular user
sudo chown -R $USER:$USER /var/www/jointloop.ovh/html
sudo chown -R $USER:$USER /var/www/festivaldellastronomia.it/html

# Make sure that permissions of our web roots are correct
sudo chmod -R 755 /var/www

# Step Two — Create Sample Pages for Each Site
cd /var/www/jointloop.ovh/html/
touch index.html
echo "<html>" >> index.html 
echo "    <head>" >> index.html
echo '        <title>Welcome to jointloop.ovh!</title>' >> index.html
echo "    </head>" >> index.html
echo "    <body>" >> index.html
echo '        <h1>Success!  The jointloop.ovh server block is working!</h1>' >> index.html
echo "    </body>" >> index.html
echo "</html>" >> index.html

# Since the file for second site is basically the same we can copy it
cd 
cp /var/www/jointloop.ovh/html/index.html /var/www/festivaldellastronomia.it/html/
sed -i -e 's/jointloop.ovh/festivaldellastronomia.it/g' /var/www/festivaldellastronomia.it/html/index.html

# Step Three — Create Server Block Files for Each Domain
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/jointloop.ovh
sudo sed -i -e 's/listen 80 default_server;/listen 80;/g' /etc/nginx/sites-available/jointloop.ovh
sudo sed -i -e 's/listen [::]:80 default_server;/listen [::]:80;/g' /etc/nginx/sites-available/jointloop.ovh
sudo sed -i -e 's,root /var/www/html;,root /var/www/jointloop.ovh/html;,g' /etc/nginx/sites-available/jointloop.ovh
sudo sed -i -e 's/server_name _/server_name jointloop.ovh www.jointloop.ovh/g' /etc/nginx/sites-available/jointloop.ovh

sudo cp /etc/nginx/sites-available/jointloop.ovh /etc/nginx/sites-available/festivaldellastronomia.it
sudo sed -i -e 's,root /var/www/jointloop.ovh/html;,root /var/www/festivaldellastronomia.it/html;,g' /etc/nginx/sites-available/festivaldellastronomia.it
sudo sed -i -e 's/server_name jointloop.ovh www.jointloop.ovh;/server_name festivaldellastronomia.it www.festivaldellastronomia.it;/g' /etc/nginx/sites-available/festivaldellastronomia.it

# Step Four — Enable your Server Blocks and Restart Nginx
sudo ln -s /etc/nginx/sites-available/jointloop.ovh /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/festivaldellastronomia.it /etc/nginx/sites-enabled/

sudo rm /etc/nginx/sites-enabled/default

sudo service nginx restart
```