mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out etc/nginx/ssl/localhost.pem \
            -keyout etc/nginx/ssl/localhost.key \
			-subj "/C=FR/ST=Lyon/L=Lyon/O=42Lyon/OU=cgangaro/CN=localhost"

mkdir var/www/localhost
mkdir var/www/localhost/wordpress
cp ./default etc/nginx/sites-available
cp ./test.php var/www/localhost
mv var/www/html/index.nginx-debian.html var/www/localhost
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
mv ./wordpress var/www/localhost/
mv ./wp-config.php var/www/localhost/wordpress/wp-config.php

service mysql start
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz

mv phpMyAdmin-4.9.0.1-all-languages var/www/localhost/phpmyadmin
mv ./config.inc.php var/www/localhost/phpmyadmin

chmod 777 autoindex.sh
chmod 600 /var/www/localhost/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/localhost/phpmyadmin

service php7.3-fpm start
echo "GRANT ALL ON *.* TO 'ohuser'@'localhost' IDENTIFIED BY 'ahmdp'" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

service nginx start
sleep infinity
