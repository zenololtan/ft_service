# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: ztan <ztan@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2020/02/06 15:06:45 by ztan           #+#    #+#                 #
#    Updated: 2020/03/06 17:52:41 by ztan          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

#		importing os
FROM	debian:buster
RUN		apt-get -y update && apt-get -y upgrade

#		opening ports
EXPOSE	80 443

#		install vim && zsh
RUN 	apt-get -y install vim
RUN 	apt-get -y install zsh
RUN 	apt-get -y install wget git
RUN		wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && exec zsh

#		install necesesry programs
RUN		apt-get install	-y wget
RUN		apt-get install -y sudo
RUN 	apt-get install -y sendmail
RUN 	apt-get install -y nginx
RUN 	apt-get install -y mariadb-server
RUN 	apt-get install -y php php-fpm php-mysql php-zip php-mbstring php-json

#		nginx config php
RUN 	mkdir /var/www/your_domain
RUN 	cp var/www/html/index.nginx-debian.html var/www/your_domain/

#		import php-admin && give rights
RUN 	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN 	tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN 	mkdir /var/www/your_domain/wordpress
RUN 	mv phpMyAdmin-4.9.0.1-all-languages /var/www/your_domain/wordpress/phpmyadmin
RUN 	chmod 755 var/www/your_domain/wordpress/phpmyadmin

#		making admin account && wp database
RUN		service mysql start && \
		mysql -e "CREATE USER 'ztan'@'%' IDENTIFIED BY 'ztan';" && \
		mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'ztan'@'%' WITH GRANT OPTION;" && \
		mysql -e "FLUSH PRIVILEGES;" && \
		mysql -e "CREATE DATABASE wordpress_db;"

#		create super user
RUN		adduser --disabled-password --gecos "" ztan
RUN		sudo adduser ztan sudo

#		install wp-cli
RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN 	chmod 755 wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN		wp cli update

#		download && configure wordpress
RUN		service mysql start && sudo -u ztan -i wp core download && \
		sudo -u ztan -i wp core config --dbname=wordpress_db --dbuser=ztan --dbpass=ztan && \
		sudo -u ztan -i wp core install --url=https://localhost/ --title=WordPress \
		--admin_user=ztan --admin_password=ztan --admin_email=zenotancodam@gmail.com
RUN		cp -r /home/ztan/. /var/www/your_domain/wordpress
RUN		chown -R www-data:www-data /var/www/your_domain/*

#		copy files
COPY	srcs/server.key etc/ssl/private
COPY	srcs/server.crt etc/ssl/certs
COPY	srcs/nginx.conf /etc/nginx/sites-enabled/
COPY	srcs/nginx.conf /etc/nginx/sites-available/
COPY	srcs/config.inc.php /var/www/your_domain/wordpress/phpmyadmin/
COPY	/srcs/start.sh /tmp
COPY	/srcs/index.sh /tmp

#		initiate services
CMD		/bin/bash tmp/start.sh