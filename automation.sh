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

#Task3
inventory_file="/var/www/html/inventory.html"
cron_file="/etc/cron.d/automation"
if [ ! -f "$inventory_file" ]
then
touch "$inventory_file"
echo "Log Type&emsp;&emsp;&emsp;&emsp;Time Created&emsp;&emsp;&emsp;&emsp;Type&emsp;&emsp;&emsp;&emsp;Size&emsp;&emsp;&emsp;&emsp;<br>" >> "$inventory_file"
fi
echo -e "<br><br>" >> $inventory_file

echo "http-d&emsp;&emsp;&emsp;&emsp;&nbsp;"$timestamp"&emsp;&emsp;&nbsp;&nbsp;tar&emsp;&emsp;&emsp;&emsp;&emsp;"$file_size"&emsp;&emsp;&emsp;<br>" >> "$inventory_file"

if [ ! -f "$cron_file" ]
then
touch "$cron_file"
echo "00 00 * * * root /root/Automation_Project/automation.sh" > "$cron_file"
fi
