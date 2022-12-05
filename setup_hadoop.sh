#!/bin/bash

## Author: Shaikh Aquib
##
## Purpose: Used to download and setup Hadoop 3.3.4 and OpenJDK8 on Debian GNU/Linux
##          and Debian/Ubuntu based systems.
##
## Usage: Execute this script with a non-root user having sudo priviledges
##        For setting up basic environment and adding user to sudo execute
##        setup_debian.sh provided along with this.
##

TASK_COMPLETION_MSG="+++++++++++++ DONE +++++++++++++\n"
HADOOP_HOME=$PWD/hadoop-3.3.4
BASH_PROFILE=/home/$USER/.bashrc
HADOOP_TAR_FILE=$HADOOP_HOME.tar.gz
JAVA_PKG_FILE=$PWD/openlogic-openjdk-8u352-b08-linux-x64-deb.deb
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

echo "[+] Downloading Hadoop"
if ! test -f $HADOOP_TAR_FILE; then
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
fi
printf $TASK_COMPLETION_MSG

echo "[+] Downloading and Install JDK8"
if ! test -f $JAVA_PKG_FILE; then
    wget https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u352-b08/openlogic-openjdk-8u352-b08-linux-x64-deb.deb	
fi
sudo dpkg -i $JAVA_PKG_FILE
sudo apt -f install
printf $TASK_COMPLETION_MSG

echo "[+] Extracting files"
if ! test -d $HADOOP_HOME; then
    tar -xvzf $HADOOP_TAR_FILE
fi
printf $TASK_COMPLETION_MSG

echo "[+] Setting up environment variables"
JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
echo "export JAVA_HOME=$JAVA_HOME"  >> $HADOOP_CONF_DIR/hadoop-env.sh
printf $TASK_COMPLETION_MSG

echo "[+] Setting SSH to run without passphrase"
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

echo "[+] Configuring Core Site"
cat core-site.xml > $HADOOP_CONF_DIR/core-site.xml
printf $TASK_COMPLETION_MSG

echo "[+] Configuring HDFS"
cat hdfs-site.xml > $HADOOP_CONF_DIR/hdfs-site.xml
printf $TASK_COMPLETION_MSG

echo "[+] Configuring Map Reduce"
cat mapred-site.xml > $HADOOP_CONF_DIR/mapred-site.xml
printf $TASK_COMPLETION_MSG

echo "[+] Configuring YARN"
cat yarn-site.xml > $HADOOP_CONF_DIR/yarn-site.xml
printf $TASK_COMPLETION_MSG

echo "[+] Format the namenode"
$HADOOP_HOME/bin/hdfs namenode -format
