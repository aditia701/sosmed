!/bin/bash

echo "Menyiapkan Installasi Database Server "    
sudo apt-get update    
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'    
sudo apt-get install -y mysql-server    
echo "============================="    

echo "Copy file mysql dan edit bind address menjadi 0.0.0.0"
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo "============================="

echo "Restart service database"
sudo service mysql stop
sudo service mysql start
echo "============================="

echo "Buat databse dan user"
sudo mysql -u root -p123 << @
CREATE DATABASE IF NOT EXISTS dbsosmed;
CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS 'devopscilsy'@'%' IDENTIFIED BY '1234567890';
GRANT ALL PRIVILEGES ON *.* TO 'devopscilsy'@'%';
FLUSH PRIVILEGES;
@
echo "=============================="