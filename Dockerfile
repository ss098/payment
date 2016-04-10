FROM ubuntu:trusty

MAINTAINER cenegd <cenegd@live.com>

RUN apt-get update
RUN apt-get -y install curl wget apache2 libapache2-mod-php5 php5-mysql php5-curl
RUN wget https://dn-iold8ot9.qbox.me/696619b4a8a322ca.py -O get-pip.py
RUN python get-pip.py
RUN rm -f get-pip.py
RUN pip install requests bs4
RUN apt-get clean
RUN apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN sed -i 's/variables_order.*/variables_order = "EGPCS"/g' /etc/php5/apache2/php.ini

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
COPY . /var/www/html

EXPOSE 80
CMD ["./start.sh"]
