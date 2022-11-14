#! /bin/bash

yum update -y
yum install python3 -y
pip3 install flask
pip3 install flask_mysql
cd /home/ec2-user && mkdir phonebook
echo ${rds-endpoint} > /home/ec2-user/phonebook/dbserver.endpoint
TOKEN="GHSAT0AAAAAABZ7LGITQ5XGSO46T6ERSOCIY3SNXVQ"
FOLDER="https://$TOKEN@raw.githubusercontent.com/abilalzengin/project-202-abilalzengin/main"
curl -s --create-dirs -o "/home/ec2-user/templates/index.html" -L "$FOLDER"/templates/index.html
curl -s --create-dirs -o "/home/ec2-user/templates/add-update.html" -L "$FOLDER"/templates/add-update.html
curl -s --create-dirs -o "/home/ec2-user/templates/delete.html" -L "$FOLDER"/templates/delete.html
curl -s --create-dirs -o "/home/ec2-user/app.py" -L "$FOLDER"/phonebook-app.py
python3 /home/ec2-user/app.py