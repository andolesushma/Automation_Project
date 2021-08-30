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
