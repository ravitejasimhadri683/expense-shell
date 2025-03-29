#!/bin/bash
component=frontend
source common.sh
stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
}

echo -n "Installing nginx: "
dnf install nginx -y  &>> $logfile
stat $?

echo -n "Configuring Proxy"
cp expense.conf /etc/nginx/default.d/expense.conf  &>> $logfile
stat $?

echo -n "starting nginx: "
systemctl enable nginx &>> $logfile
systemctl start nginx  &>> $logfile
stat $?

echo -n "Remove old content from $component" 
rm -rf /usr/share/nginx/html/*  
stat $?

echo -n "Downloading $component content:"
curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> $logfile
stat $?

cd /usr/share/nginx/html 
unzip /tmp/$component.zip &>> $logfile

# vim /etc/nginx/default.d/expense.conf   ( empty the file if any and add the below content )

echo -n "Resarting nginx: "
systemctl restart nginx 
stat $?
# systemctl status nginx 

echo -n "******* Frontend completed****************"
