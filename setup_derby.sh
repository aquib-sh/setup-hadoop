#!/bin/bash

## Run this script only after sourcing bashrc after running setup_hive.sh

HIVE_HOME=$PWD/apache-hive-3.1.3-bin
HADOOP_HOME=$PWD/hadoop-3.3.4
DERBY_HOME=$PWD/db-derby-10.14.2.0-bin

echo "[+] Starting the Derby Network Server"
$DERBY_HOME/bin/startNetworkServer -h 0.0.0.0 > /dev/null 2>&1 &

echo "[+] Initializing Database Schema"
$HIVE_HOME/bin/schematool -dbType derby -initSchema
