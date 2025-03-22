#!/bin/bash
echo -n "Installing nginx: "
dnf install nginx -y  &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "Enable nginx: "
systemctl enable nginx &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "starting nginx: "
systemctl start nginx  &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "Remove old content" 
rm -rf /usr/share/nginx/html/*  
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
echo -n "Downloading frontend content:"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> /tmp/frontend.log
# vim /etc/nginx/default.d/expense.conf   ( empty the file if any and add the below content )

# proxy_http_version 1.1;

# location /api/ { proxy_pass http://localhost:8080/; }

# location /health {
# stub_status on;
# access_log off;
# }
echo -n "Resarting nginx: "
systemctl restart nginx 
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
# systemctl status nginx 
