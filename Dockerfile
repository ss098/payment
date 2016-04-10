FROM centos:7.2.1511

MAINTAINER cenegd <cenegd@live.com>

RUN yum install wget -y
RUN wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -P /etc/yum.repos.d/
RUN yum clean all
RUN yum makecache

RUN yum install httpd php php-mysql php-pdo python -y
RUN wget https://dn-iold8ot9.qbox.me/696619b4a8a322ca.py -O get-pip.py
RUN python get-pip.py
RUN rm -f get-pip.py
RUN pip install requests bs4

COPY . /var/www/html

EXPOSE 80
