#!/bin/bash

JAVA_HOME=$PWD/openlogic-openjdk-8u352-b08-linux-x64
HADOOP_HOME=$PWD/hadoop-3.3.4
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
HADOOP_MAPRED_HOME=$HADOOP_HOME     
HADOOP_COMMON_HOME=$HADOOP_HOME         
HADOOP_HDFS_HOME=$HADOOP_HOME            
YARN_HOME=$HADOOP_HOME               
PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin

TASK_COMPLETION_MSG="+++++++++++++ DONE +++++++++++++\n"
BASH_PROFILE=/home/$USER/.bashrc
HADOOP_TAR_FILE=$HADOOP_HOME.tar.gz
JAVA_TAR_FILE=$JAVA_HOME.tar.gz

echo "[+] Downloading Hadoop"
if ! test -f $HADOOP_TAR_FILE; then
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
fi
printf TASK_COMPLETION_MSG

echo "[+] Downloading JDK"
if ! test -f $JAVA_TAR_FILE; then
    wget https://builds.openlogic.com/downloadJDK/openlogic-openjdk/8u352-b08/openlogic-openjdk-8u352-b08-linux-x64.tar.gz
fi
printf TASK_COMPLETION_MSG

echo "[+] Extracting files"
if ! test -d $HADOOP_HOME; then
    tar -xvzf $HADOOP_TAR_FILE
fi

if ! test -d $JAVA_HOME; then
    tar -xvzf $JAVA_TAR_FILE
fi
printf TASK_COMPLETION_MSG

if ! test -f $BASH_PROFILE; then
    touch $BASH_PROFILE
fi

echo "[+] Setting up environment variables"
echo "export JAVA_HOME=$JAVA_HOME"                   >> $BASH_PROFILE
echo "export HADOOP_HOME=$HADOOP_HOME"               >> $BASH_PROFILE
echo "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR"       >> $BASH_PROFILE
echo "export HADOOP_MAPRED_HOME=$HADOOP_MAPRED_HOME" >> $BASH_PROFILE
echo "export HADOOP_COMMON_HOME=$HADOOP_COMMON_HOME" >> $BASH_PROFILE
echo "export HADOOP_HDFS_HOME=$HADOOP_HDFS_HOME"     >> $BASH_PROFILE
echo "export YARN_HOME=$YARN_HOME"                   >> $BASH_PROFILE
echo "export PATH=$PATH"                             >> $BASH_PROFILE
printf TASK_COMPLETION_MSG

source /home/$USER/.bashrc

echo "[+] Configuring Core Site"
cat core-site.xml > $HADOOP_CONF_DIR/core-site.xml
printf TASK_COMPLETION_MSG

echo "[+] Configuring HDFS"
cat hdfs-site.xml > $HADOOP_CONF_DIR/hdfs-site.xml
printf TASK_COMPLETION_MSG

echo "[+] Configuring Map Reduce"
cat mapred-site.xml > $HADOOP_CONF_DIR/mapred-site.xml
printf TASK_COMPLETION_MSG

echo "[+] Configuring YARN"
cat yarn-site.xml > $HADOOP_CONF_DIR/yarn-site.xml
printf TASK_COMPLETION_MSG

hadoop namenode -format
