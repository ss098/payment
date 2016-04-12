#!/bin/bash

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
python /payment.py &
/usr/sbin/apache2ctl -D FOREGROUND &
