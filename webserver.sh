!/bin/bash

echo "Install web-server"    
sudo apt-get update     
sudo apt-get install -y apache2 php php-mysql mysql-client libapache2-mod-php
echo "========================="   

echo "Buat direktori untuk menyimpan file"
sudo mkdir /var/www/html/sosmed
sudo mkdir /var/www/html/wordpress
sudo mkdir /var/www/html/landingpage
echo "========================="


echo "Change owner dari direktori yang dibuat"
sudo chown -R vagrant:vagrant /var/www/html/landingpage
sudo chown -R vagrant:vagrant /var/www/html/wordpress
sudo chown -R vagrant:vagrant /var/www/html/sosmed
echo "========================="

echo "Change mode di direktori yang dibuat"
sudo chmod -R 755 /var/www/html
echo "========================="

echo "Clone file landing page kemudian pindahkan ke direktori yang sudah disiapkan"
git clone https://github.com/aditia701/landing-page.git
mv landing-page/* /var/www/html/landingpage
rm -rf landing-page
echo "========================="

echo "Clone file wordpress kemudian pindahkan ke direktori yang sudah disiapkan"
git clone https://github.com/aditia701/WordPress.git
mv WordPress/* /var/www/html/wordpress
rm -rf WordPress
echo "========================="

echo "Copy file wpconfig kemudian ganti database, username,password, dan localhost"
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i 's/database_name_here/wordpress_db/g' /var/www/html/wordpress/wp-config.php
sudo sed -i 's/username_here/devopscilsy/g' /var/www/html/wordpress/wp-config.php
sudo sed -i 's/password_here/1234567890/g' /var/www/html/wordpress/wp-config.php
sudo sed -i 's/localhost/192.168.56.12/g' /var/www/html/wordpress/wp-config.php
echo "========================="

echo "Clone file sosmed kemudian pindahkan ke direktori yang sudah disiapkan"
git clone https://github.com/aditia701/sosmed.git
mv sosmed/* /var/www/html/sosmed
rm -rf sosmed
echo "========================="

ehco "Ubah localhost menjadi IP databse di file config.php kemudian dump sql"
sed -i 's/localhost/192.168.56.12/g' /var/www/html/sosmed/config.php
echo "Dump SQL file"
mysql -h 192.168.56.12 -u devopscilsy -p1234567890 dbsosmed < /var/www/html/sosmed/dump.sql
echo "========================="

echo "Konfigurasi Apache"
sudo cp /var/www/html/landingpage/landingpage.conf /etc/apache2/sites-enabled/
sudo cp /var/www/html/landingpage/wordpress.conf /etc/apache2/sites-enabled/
sudo cp /var/www/html/landingpage/sosmed.conf /etc/apache2/sites-enabled/
echo "========================"

echo "Restart Service"
sudo systemctl restart apache2
echo "Konfigurasi Apache Selesai"
echo "========================"