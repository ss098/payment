FROM eboraas/apache-php

MAINTAINER cenegd <cenegd@live.com>

RUN apt-get -y install php5-mysql

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY . /var/www/html
COPY start.sh /start.sh
RUN rm -f /var/www/html/start.sh && rm -f /var/www/html/README.md

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
