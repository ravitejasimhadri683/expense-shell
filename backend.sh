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
logfile= "/tmp/$component.log"
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

