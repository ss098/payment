FROM eboraas/apache-php

MAINTAINER cenegd <cenegd@live.com>

RUN apt-get -y install python wget
RUN wget https://dn-iold8ot9.qbox.me/696619b4a8a322ca.py -O get-pip.py
RUN python get-pip.py
RUN rm -f get-pip.py
RUN pip install requests bs4
RUN apt-get clean
RUN apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /var/www/html

EXPOSE 80
CMD ["./start.sh"]
