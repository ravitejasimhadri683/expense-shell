#!/bin/bash
# Check if the script is being run as root (UID 0)
   if [ "$(id -u)" -eq "0" ]; then
       echo "Running as root..."

   else
       echo "Not running as root. Exiting..."
       echo -e "\n For example: \n\t run as \e[35m sudo bash $0 \e[0m"
       exit 1  
   fi
component="backend"
appUser="expense"
logfile= "/tmp/$component.log" &>> logfile
stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
}
echo -n "Installing node js: "
dnf dnf module disable nodejs -y  &>> logfile
dnf module enable nodejs:20 -y &>> logfile
dnf install nodejs -y &>> logfile
stat $?

echo -n "Creating application User : "
id $appUser &>> logfile
if [ $? -eq 0 ];then
    echo -e "\e[32m User is already exist...so, SKIPPING it \e[0m"
else   
    useradd $appUser &>> logfile
    stat $?
fi
mkdir /app &>> logfile

echo -n "Download the application to create the app directory: "
curl -o /tmp/backend.zip https://expense-web-app.s3.amazonaws.com/$component.zip  &>> logfile
stat $?

echo -n "Configuring the system services: "
cp $component.service /etc/systemd/system/$component.service
stat $?

echo -n "Extracting the $component content "
cd /app
unzip -o /tmp/backend.zip &>> logfile
stat $?

echo -n "Generating the $component artifacts: "
npm install &>> logfile
stat $?

echo -n "Configuring the permission: "
chmod -R 775 /app && chown -R expense:expense /app 
stat $?

echo -n "Installing mysql: "
dnf install mysql-server -y  &>> logfile
stat $?

echo -n "Injecting schema from backend app"
mysql -h 172.31.13.88 -uroot -pExpenseApp@1 < /app/schema/backend.sql 


echo -n "start the backend service: "
systemctl daemon-reload &>> logfile
systemctl enable backend   &>> logfile
systemctl start backend   &>> logfile
stat $?




