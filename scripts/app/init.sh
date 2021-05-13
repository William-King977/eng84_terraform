#!/bin/bash
. /etc/profile
cd /home/ubuntu/eng84_cicd_jenkins/app
node seeds/seed.js

sudo pm2 kill
sudo -E pm2 start app.js