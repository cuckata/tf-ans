this is a repo for a quick config of: 
-VPC
-Subnet
-IGW
-Route table
-Security Group
-EC2 instance
-etc
in AWS using terraform.

Included a random string generator in random.tf

Also EC2 config with ansible to:
-update cache
-install git
-create a dir
-add new user
-grant sudo privileges to the new user
-install nginx
-create a simple html page
-start and enable the nginx service
