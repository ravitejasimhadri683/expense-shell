#!/bin/bash
echo "Installing nginx: "
dnf install nginx -y  &>> /tmp/frontend.log
echo "Enable nginx: "
systemctl enable nginx &>> /tmp/frontend.log
echo "starting nginx: "
systemctl start nginx  &>> /tmp/frontend.log
# rm -rf /usr/share/nginx/html/*  
# curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip
# cd /usr/share/nginx/html 
# unzip /tmp/frontend.zip
# vim /etc/nginx/default.d/expense.conf   ( empty the file if any and add the below content )

# proxy_http_version 1.1;

# location /api/ { proxy_pass http://localhost:8080/; }

# location /health {
# stub_status on;
# access_log off;
# }

# systemctl restart nginx 
# systemctl status nginx 
