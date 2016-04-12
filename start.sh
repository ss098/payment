#!/bin/bash

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
/usr/sbin/apache2ctl -D FOREGROUND
python /payment.py
