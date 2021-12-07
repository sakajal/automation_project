# automation_project

## Description
The bash script is used to perform below activities on the Ubuntu server.
```bash
Updates the package information
Ensures that HTTP Apache server is installed
Ensures that HTTP Apache server is running
Ensures that HTTP Apache service is enabled
Archiving HTTP Server logs from /var/log/apache2/ to S3
Sets up cronjob to archive log files on daily at midnight
Creates and records historical data of archival at location /var/www/html/inventory.html
```

## Prerequisites
