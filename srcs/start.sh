# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    start.sh                                           :+:    :+:             #
#                                                      +:+                     #
#    By: ztan <ztan@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/02 12:35:26 by ztan           #+#    #+#                 #
#    Updated: 2020/03/06 17:51:33 by ztan          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

service mysql start
service php7.3-fpm start
service nginx start
echo "127.0.0.1 localhost localhost.localdomain $(hostname)" >> /etc/hosts && \
service sendmail start
echo "alias index='bash /tmp/index.sh'" >> ~/.zshrc
exec zsh
/bin/bash