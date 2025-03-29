#!/bin/bash
component=mysql
source common.sh

   if [ -z $1 ]; then
       echo -e "\e[31m Please provide the password for mysql \e[0m"
       echo -e "\e[35m \t\t For Example: sudo bash $0 password \e[0m"
       exit 2
   fi

echo -n "Installing mysql: "
dnf install mysql-server -y  &>> $logfile
stat $?

echo -n "starting mysql: "
systemctl enable  mysqld   &>> $logfile
systemctl start  mysqld  &>> $logfile
stat $?

echo -n "setup the password for mysql: "
mysql_secure_installation --set-root-pass $1 &>> $logfile
stat $?



