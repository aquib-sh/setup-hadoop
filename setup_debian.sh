#!/bin/bash 
#
## Author: Shaikh Aquib
##
## Purpose: Used to setup suitable environment for installation of Hadoop 3.3.4 and OpenJDK8 on Debian GNU/Linux
##
## Usage: Execute this script as root
##

apt install ssh sudo
apt remove pdsh

echo "Enter your non-root username:"
read username

echo "PATH=$PATH:/usr/bin:/usr/sbin" >> $HOME/.bashrc
echo "$username ALL=(ALL:ALL) ALL" >> /etc/sudoers
