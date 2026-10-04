#!/bin/bash
apt update && apt install apache2-utils -y 

echo "10.79.3.2 www.k31.com" >> /etc/hosts
echo "10.79.2.2 static.k31.com" >> /etc/hosts

ab -n 250 -c 10 http://www.k31.com/
ab -n 250 -c 10 http://static.k31.com/