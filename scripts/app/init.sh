#!/bin/bash
#echo export DB_HOST='mongodb://59.59.4.109:27017/posts' | sudo tee -a /etc/profile
. /etc/profile
cd /home/ubuntu/eng84_cicd_jenkins/app
node seeds/seed.js

sudo pm2 kill
sudo -E pm2 start app.js