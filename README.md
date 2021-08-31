Script is used to automate the below tasks on Apache
1. Update of package details and the package list
2. Check if apache2 is installed on machine and install if it is not
3. Check if apache2 process is running and start if it is not
4. Check if apache2 service is enabled and enable it if it is disabled
5. Create a tar file for logs located at /var/log/apache2
6. Move the tar file created in step 5 to s3 bucket using AWS CLI
7. Create HTML file with details of tar file created
8. Scheudule cron job to run the script everyday
