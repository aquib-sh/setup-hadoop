#!/bin/bash

HIVE_TAR_FILE=$PWD/apache-hive-3.1.3-bin.tar.gz
DERBY_TAR_FILE=$PWD/db-derby-10.14.2.0-bin.tar.gz

HIVE_HOME=$PWD/apache-hive-3.1.3-bin
HADOOP_HOME=$PWD/hadoop-3.3.4
DERBY_HOME=$PWD/db-derby-10.14.2.0-bin

TASK_COMPLETION_MSG="+++++++++++++ DONE +++++++++++++\n"

echo "[+] Downloading Hive"
if ! test -f $HIVE_TAR_FILE; then
    wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
fi
printf $TASK_COMPLETION_MSG

echo "[+] Downloading Derby"
if ! test -f $DERBY_TAR_FILE; then
    wget https://archive.apache.org/dist/db/derby/db-derby-10.14.2.0/db-derby-10.14.2.0-bin.tar.gz
fi

echo "[+] Extracting Hive"
if ! test -d $HIVE_HOME; then
    tar -xvzf $HIVE_TAR_FILE
fi

echo "[+] Extracting Derby"
if ! test -d $DERBY_HOME; then
    tar -xvzf $DERBY_TAR_FILE
fi

echo "[+] Adding Hive to bash profile"
echo "PATH=$PATH:$HIVE_HOME/bin" >> $HOME/.bashrc

echo "[+] Setting up Hive directories"
$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir       /user
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse

echo "[+] Creating Derby data directory"
if ! test -d $DERBY_HOME/data; then
    mkdir $DERBY_HOME/data
fi

echo "[+] Configure Hive to use Derby"
HIVE_SITE_CONFIG=$(cat $PWD/hive-site.xml)
JPOS_PROPERTIES=$(cat $PWD/jpos.properties)
IP_ADDRESS=$(ip addr | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

SUBSTITUTED_HIVE_CONFIG=${HIVE_SITE_CONFIG//hadoop1/$IP_ADDRESS}
SUBSTITUTED_JPOS_PROPERTIES=${JPOS_PROPERTIES//hadoop1/$IP_ADDRESS}

echo $SUBSTITUTED_HIVE_CONFIG > $HIVE_HOME/conf/hive-site.xml
echo $SUBSTITUTED_JPOS_PROPERTIES > $HIVE_HOME/conf/jpox.properties

echo "[+] Copy jar files from Derby to Hive"
cp $DERBY_HOME/lib/* $HIVE_HOME/lib/
