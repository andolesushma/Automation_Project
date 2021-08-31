#!/bin/bash
name="sushma"
s3_bucket="upgrad-sushma"
sudo apt update -y
dpkg -s apache2 | grep installed > /dev/null 2>&1
if [[ $? == "0" ]]; then
        echo "Apache2 is installed"
else
        echo "Apache2 is not installed"
        apt install apache2 -y
fi

# Check if apache is running
systemctl status apache2 | grep running > /dev/null 2>&1

if [ $? == "0" ]; then
        echo "Apache2 is running"
else
        echo "Apache2 is not running"
        systemctl start apache2
fi

# Check if apache service is enabled
systemctl is-enabled apache2 > /dev/null 2>&1
if [ $? == "0" ]; then
        echo "Apache2 is enabled"
else
        echo "Apache2 is not enabled"
        systemctl enable apache2
fi

#Copying files to s3
cd /var/log/apache2
tar -cvf /tmp/$name-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar *.log

timestamp=$(date '+%d%m%Y-%H%M%S')
aws s3 cp /tmp/$name-httpd-logs-${timestamp}.tar s3://$s3_bucket/$name-httpd-logs-${timestamp}.tar

#Update inventory.html
File=/var/www/html/inventory.html
if [ -f $File ]; then
        echo "Inventory file exists"
else
        echo "Inventory file does not exist, creating it"
        touch $File
        cat > $File << EOF
<!DOCTYPE html>
<html>
<body>
<h1 style="font-size:20px;">Log Type &emsp; Time Created &emsp; Type &emsp; Size</h1>
EOF
fi
cd /tmp
size=$(ls -lh $name-httpd-logs-${timestamp}.tar | awk '{print $5}')
echo "<p>httpd-log &emsp; ${timestamp} &emsp; tar &emsp; ${size}</p>" >> $File

#Checking if cron file exists
cron_file=/etc/cron.d/automation
if [ -f $cron_file ]; then
        echo "cron file exists"
else
        echo "cron file does not exist, creating it"
        touch $cron_file
        cat > $cron_file << EOF
0 0 * * * root /root/Automation_Project/automation.sh
EOF
fi
