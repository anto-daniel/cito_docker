#!/bin/bash

/usr/bin/mysqld_safe &
sleep 10
/usr/bin/mysql -uroot -pCito123 < /create_cito.sql

