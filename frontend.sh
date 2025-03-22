#!/bin/bash
component="frontend"
stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
}
echo -n "Installing nginx: "
dnf install nginx -y  &>> /tmp/$component.log
stat $?

echo -n "Enable nginx: "
systemctl enable nginx &>> /tmp/$component.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "starting nginx: "
systemctl start nginx  &>> /tmp/$component.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "Remove old content from $component" 
rm -rf /usr/share/nginx/html/*  
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "Downloading $component content:"
curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/$component.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
cd /usr/share/nginx/html 
unzip /tmp/$component.zip &>> /tmp/$component.log
cp expense.conf /etc/nginx/default.d/expense.conf  &>> /tmp/fron$component.log
# vim /etc/nginx/default.d/expense.conf   ( empty the file if any and add the below content )

echo -n "Resarting nginx: "
systemctl restart nginx 
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
# systemctl status nginx 
