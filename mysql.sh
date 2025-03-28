#!/bin/bash
# Check if the script is being run as root (UID 0)
   if [ "$(id -u)" -eq "0" ]; then
       echo "Running as root..."

   else
       echo "Not running as root. Exiting..."
       echo -e "\n For example: \n\t run as \e[35m sudo bash $0 \e[0m"
       exit 1  
   fi

   if [ -z $1 ]; then
       echo -e "\e[31m Please provide the password for mysql \e[0m"
       echo -e "\e[35m \t\t For Example: sudo bash $0 password \e[0m"
       exit 2
   fi

component="mysql"
logfile= "/tmp/$component.log" &>> logfile
stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
}
echo -n "Installing mysql: "
dnf install mysql-server -y  &>> logfile
stat $?

echo -n "starting mysql: "
systemctl enable  mysqld   &>> logfile
systemctl start  mysqld  &>> logfile
stat $?

echo -n "setup the password for mysql: "
mysql_secure_installation --set-root-pass $1 &>> logfile
stat $?



