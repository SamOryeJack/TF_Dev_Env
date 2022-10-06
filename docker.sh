#!/bin/bash
log=log_file.txt
 
# create log file or overrite if already present
printf "Log File - " > $log
 
# append date to log file
date >> $log
 
x=$(( 3 + 1 ))
# append some data to log file
echo value of x is $x >> $log

sudo apt-get update 
sudo apt-get upgrade y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y