#!/bin/bash

sudo dnf update -y   
sudo dnf install -y mariadb105-server   # maria db
sudo dnf install -y httpd wget php-fpm php-mysqli  #php-mysqli  interafce for php to connect with sql databases 


# Start Apache and mariadb services
sudo systemctl start httpd         # Start Apache HTTP server
sudo systemctl enable httpd        # Enable Apache to start on system boot
sudo systemctl start mariadb        # Start MySQL server
sudo systemctl enable mariadb       # Enable MySQL to start on system boot


echo "Creating WordPress database and user..."
MYSQL_ROOT_PASSWORD=""root
MYSQL_WP_USER="wpuser"
MYSQL_WP_PASSWORD="wp_user_password"
MYSQL_WP_DB="wpdatabase"



expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Switch to unix_socket authentication [Y/n]\"
send \"n\r\"
expect \"Change the root password? [Y/n]\"
send \"n\r\"
expect \"Remove anonymous users? [Y/n]\"
send \"n\r\"
expect \"Disallow root login remotely? [Y/n]\"
send \"n\r\"
expect \"Remove test database and access to it? [Y/n]\"
send \"n\r\"
expect \"Reload privilege tables now? [Y/n]\"
send \"n\r\"
expect eof
"

# Secure MySQL installation (you will be prompted for root password)
# sudo mysql_secure_installation     # Secure MySQL installation by setting root password and other security settings

# Create a MySQL database and user for WordPress


sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} <<MYSQL_SCRIPT
CREATE DATABASE ${MYSQL_WP_DB} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;  # Create WordPress database with UTF-8 encoding
CREATE USER '${MYSQL_WP_USER}'@'localhost' IDENTIFIED BY '${MYSQL_WP_PASSWORD}';   # Create MySQL user for WordPress
GRANT ALL ON ${MYSQL_WP_DB}.* TO '${MYSQL_WP_USER}'@'localhost';                   # Grant all privileges on WordPress database to the user
FLUSH PRIVILEGES;                                                                 # Flush privileges to apply changes
MYSQL_SCRIPT

# Download and install WordPress
sudo yum install -y wget           # Install wget to download files
cd /tmp                            # Navigate to temporary directory
wget https://wordpress.org/latest.tar.gz   # Download the latest WordPress release
tar -zxvf latest.tar.gz            # Extract WordPress files
sudo rsync -avP /tmp/wordpress/ /var/www/html/   # Copy WordPress files to Apache document root
sudo chown -R apache:apache /var/www/html/       # Set ownership of WordPress files to Apache user
sudo chmod -R 755 /var/www/html/     # Set permissions on WordPress files and directories

# Configure WordPress
cd /var/www/html                    # Navigate to WordPress installation directory
sudo cp wp-config-sample.php wp-config.php   # Create WordPress configuration file from sample
sudo sed -i 's/database_name_here/'${MYSQL_WP_DB}'/g' wp-config.php   # Set WordPress database name in configuration
sudo sed -i 's/username_here/'${MYSQL_WP_USER}'/g' wp-config.php      # Set WordPress database user in configuration
sudo sed -i 's/password_here/'${MYSQL_WP_PASSWORD}'/g' wp-config.php  # Set WordPress database password in configuration
sudo systemctl restart httpd        # Restart Apache to apply changes

# Clean up
sudo rm -rf /tmp/wordpress         # Remove temporary WordPress files
sudo rm /tmp/latest.tar.gz         # Remove downloaded WordPress archive

echo "WordPress installation is complete. You can access your site at http://your_ec2_instance_public_ip/"
