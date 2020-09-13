#!/bin/bash

# Remove sudos

# Request port number for firewall settings
echo What port will you use for Pritunl?
read port

# Update and Upgrade
sudo apt-get update --assume-yes && sudo apt-get upgrade --assume-yes

# Configure and enable UFW 
sudo ufw allow 22
sudo ufw allow 443
sudo ufw allow $port/udp
sudo ufw enable --assume-yes

# install hyper-v tools
echo installing hyper-v tools
sudo apt-get install linux-azure --assume-yes
 
# Install Pritunl and MongoDB
sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list << EOF
deb https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse
EOF

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt bionic main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
echo installing pritunl and mongodb
sudo apt-get --assume-yes install pritunl mongodb-server
sudo systemctl start pritunl mongodb
sudo systemctl enable pritunl mongodb

# Deploy remote management tools here


# Get key and default password
sudo pritunl setup-key
read -p "Enter the above key in https://<serverip> then press Enter"
sudo pritunl default-password
