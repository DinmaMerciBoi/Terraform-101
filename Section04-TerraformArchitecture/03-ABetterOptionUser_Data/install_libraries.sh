#!/bin/bash
echo "Installing tree, jq, and nginx"
apt -y update
apt install tree jq -y
# apt install nginx -y
# systemctl enable nginx