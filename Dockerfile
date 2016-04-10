FROM eboraas/apache-php

MAINTAINER cenegd <cenegd@live.com>

RUN apt-get -y install python wget php5-mysql
RUN wget https://dn-iold8ot9.qbox.me/696619b4a8a322ca.py -O get-pip.py
RUN python get-pip.py
RUN rm -f get-pip.py
RUN pip install requests bs4 html5lib
RUN apt-get clean
RUN apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY . /var/www/html
COPY payment.py /payment.py
COPY start.sh /start.sh
EXPOSE 80

RUN ["/bin/bash", "/start.sh"]
