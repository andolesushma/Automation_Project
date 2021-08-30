Script is used to automate the below tasks on Apache
    Update of package details and the package list
    Check if apache2 is installed on machine and install if it is not
    Check if apache2 process is running and start if it is not
    Check if apache2 service is enabled and enable it if it is disabled
    Create a tar file for logs located at /var/log/apache2
    Move the tar file created in step 5 to s3 bucket using AWS CLI
