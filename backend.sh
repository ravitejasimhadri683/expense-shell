#!/bin/bash
# Check if the script is being run as root (UID 0) 
component=backend
appUser="expense"
rootPass=$1
source common.sh 

   if [ -z $1 ]; then
       echo -e "\e[31m Please provide the password for mysql root user\e[0m"
       echo -e "\e[35m \t\t For Example: sudo bash $0 password \e[0m"
       exit 2
   fi

echo -n "Installing node js: "
dnf dnf module disable nodejs -y  &>> $logfile
dnf module enable nodejs:20 -y &>> $logfile
dnf install nodejs -y &>> $logfile
stat $?

echo -n "Creating application User : "
id $appUser &>> $logfile
if [ $? -eq 0 ];then
    echo -e "\e[32m User is already exist...so, SKIPPING it \e[0m"
else   
    useradd $appUser &>> $logfile
    stat $?
fi
mkdir /app &>> $logfile

echo -n "Download the application to create the app directory: "
curl -o /tmp/backend.zip https://expense-web-app.s3.amazonaws.com/$component.zip  &>> $logfile
stat $?

echo -n "Configuring the system services: "
cp $component.service /etc/systemd/system/$component.service
stat $?

echo -n "Extracting the $component content "
cd /app
unzip -o /tmp/backend.zip &>> $logfile
stat $?

echo -n "Generating the $component artifacts: "
npm install &>> $logfile
stat $?

echo -n "Configuring the permission: "
chmod -R 775 /app && chown -R expense:expense /app 
stat $?

echo -n "Installing mysql: "
dnf install mysql-server -y &>> $logfile
stat $?

echo -n "Injecting schema from backend app"
mysql -h  mysql.cloud-apps-learn.site -uroot -p$rootPass < /app/schema/backend.sql 
stat $?


echo -n "start the backend service: "
systemctl daemon-reload &>> $logfile
systemctl enable backend   &>> $logfile
systemctl start backend   &>> $logfile
stat $?




