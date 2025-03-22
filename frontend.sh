#!/bin/bash
# Check if the script is being run as root (UID 0)
   if [ "$(id -u)" -eq "0" ]; then
       echo "Running as root..."

   else
       echo "Not running as root. Exiting..."
       echo -e "\n For example: \n\t run as \e[35m sudo bash $0 \e[0m"
       exit 1  
   fi
component="frontend"
logfile= "/tmp/frontend.log"
stat(){
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failed \e[0m"
fi
}
echo -n "Installing nginx: "
dnf install nginx -y  &>> logfile
stat $?

echo -n "Configuring Proxy"
cp expense.conf /etc/nginx/default.d/expense.conf  &>> logfile
stat $?

echo -n "starting nginx: "
systemctl enable nginx &>> logfile
systemctl start nginx  &>> logfile
stat $?

echo -n "Remove old content from $component" 
rm -rf /usr/share/nginx/html/*  
stat $?

echo -n "Downloading $component content:"
curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> logfile
stat $?

cd /usr/share/nginx/html 
unzip /tmp/$component.zip &>> logfile

# vim /etc/nginx/default.d/expense.conf   ( empty the file if any and add the below content )

echo -n "Resarting nginx: "
systemctl restart nginx 
stat $?
# systemctl status nginx 
