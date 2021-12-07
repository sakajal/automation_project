#!/bin/bash
bucket_name="upgrad-kajal"
name="Kajal"
mkdir tmp
apt update -y
dpkg -s apache2

#Check apache2 is installed
if [ $? -ne 0 ]
then
sudo apt install apache2
sudo systemctl start apache2
sudo service apache2 start
fi
apache_status=$(sudo systemctl is-enabled apache2)

#Check apache2 is enabled
if [ "$apache_status" != "enabled" ]
then
sudo systemctl enable apache2
fi
apache_started=$(sudo systemctl is-active apache2)

#check apache is running
if [ "$apache_started" != "active" ]
then
service apache2 start
fi
timestamp=$(date '+%d%m%Y-%H%M%S')
cd tmp
filename="Kajal-httpd-logs-$timestamp.tar"
echo "$filename"
tar -vcf "$filename" /var/log/apache2/*.log
aws s3 cp "$filename" s3://"$bucket_name"/"$filename"
file_size=$(du -h "$filename" | cut -f1)