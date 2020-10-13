mkdir /var/www/localhost && touch /var/www/localhost/info.php
echo "<?php phpinfo(); ?>" >> /var/www/localhost/info.php

mv ./tmp/nginx-conf /etc/nginx/sites-available/localhost
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
rm -rf /etc/nginx/sites-enabled/default

service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=asambron' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

mkdir /var/www/localhost/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/localhost/phpmyadmin
mv ./tmp/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/config.inc.php

cd /var/www/localhost/
cp /tmp/wordpress.tar.gz ./
tar xf ./wordpress.tar.gz && rm -rf wordpress.tar.gz
chmod 755 -R wordpress

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

service php7.3-fpm start
service nginx start
bash
