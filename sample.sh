#!/bin/bash

/usr/bin/mysqld_safe &
sleep 10
/usr/bin/mysql -uroot -pCito123 -e "create citoengine;" 
/usr/bin/mysql -uroot -pCito123 -e "GRANT ALL PRIVILEGES ON citoengine.* TO 'citoengine_user'@'localhost' IDENTIFIED BY 'MINISTRYOFSILLYWALKS' with GRANT OPTION;"
