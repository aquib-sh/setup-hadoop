#!/bin/bash 

# Script for some basic setup before installing Hadoop
apt install ssh sudo
apt remove pdsh

echo "Enter your non-root username:"
read username

echo "$username ALL=(ALL:ALL) ALL" >> /etc/sudoers
