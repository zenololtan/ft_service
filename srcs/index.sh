# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    index.sh                                           :+:    :+:             #
#                                                      +:+                     #
#    By: ztan <ztan@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2020/03/06 15:50:58 by ztan           #+#    #+#                 #
#    Updated: 2020/03/06 17:12:51 by ztan          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

line_num=16

if [ $1 == "off" ]
then
	sed -i -e "${line_num}s/on/off/" /etc/nginx/sites-enabled/nginx.conf 
	sed -i -e "${line_num}s/on/off/" /etc/nginx/sites-available/nginx.conf
fi
if [ $1 == "on" ]
then
	sed -i -e "${line_num}s/off/on/" /etc/nginx/sites-enabled/nginx.conf
	sed -i -e "${line_num}s/off/on/" /etc/nginx/sites-available/nginx.conf
fi

sed -n ${line_num}p /etc/nginx/sites-enabled/nginx.conf
sed -n ${line_num}p /etc/nginx/sites-available/nginx.conf

service nginx restart
