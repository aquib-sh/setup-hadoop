#!/bin/bash

function print_task_completion() {
    echo "+++++++++++++ DONE +++++++++++++"
    echo
}

echo "[+] Downloading Java"
if ! test -f "hadoop-3.3.4.tar.gz"; then
    wget https://download.java.net/java/GA/jdk19.0.1/afdd2e245b014143b62ccb916125e3ce/10/GPL/openjdk-19.0.1_linux-x64_bin.tar.gz
fi
print_task_completion

echo "[+] Downloading Hadoop"
if ! test -f "openjdk-19.0.1_linux-x64_bin.tar.gz"; then
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
fi
print_task_completion

echo "[+] Extracting files"
if ! test -d "hadoop-3.3.4"; then
    tar -xvzf hadoop-3.3.4.tar.gz
fi

if ! test -d "jdk-19.0.1"; then
    tar -xvzf openjdk-19.0.1_linux-x64_bin.tar.gz
fi
print_task_completion

BASH_PROFILE=/home/$USER/.bashrc
if ! test -f $BASH_PROFILE; then
    touch $BASH_PROFILE
fi

echo "[+] Setting up environment variables"
echo "export JAVA_HOME=$PWD/jdk-19.0.1"                         >> /home/$USER/.bashrc
echo "export HADOOP_HOME=$PWD/hadoop-3.3.4"                     >> /home/$USER/.bashrc
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop"           >> /home/$USER/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME"                   >> /home/$USER/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME"                   >> /home/$USER/.bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME"                     >> /home/$USER/.bashrc
echo "export YARN_HOME=$HADOOP_HOME"                            >> /home/$USER/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/bin"                       >> /home/$USER/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin"        >> /home/$USER/.bashrc
print_task_completion

source /home/$USER/.bashrc

echo "[+] Configuring Core Site"
echo '<?xml version="1.0" encoding="UTF-8"?>'                      > $HADOOP_CONF_DIR/core-site.xml
echo '<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>' >> $HADOOP_CONF_DIR/core-site.xml
echo '<configuration>'                                             >> $HADOOP_CONF_DIR/core-site.xml
echo '<property>'                                                  >> $HADOOP_CONF_DIR/core-site.xml
echo '<name>fs.default.name</name>'                                >> $HADOOP_CONF_DIR/core-site.xml
echo '<value>hdfs://localhost:9000</value>'                        >> $HADOOP_CONF_DIR/core-site.xml
echo '</property>'                                                 >> $HADOOP_CONF_DIR/core-site.xml
echo '</configuration>'                                            >> $HADOOP_CONF_DIR/core-site.xml
print_task_completion

echo "[+] Configuring HDFS"
echo '<?xml version="1.0" encoding="UTF-8"?>'                      > $HADOOP_CONF_DIR/hdfs-site.xml
echo '<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>' >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<configuration>'                                             >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<property>'                                                  >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<name>dfs.replication</name>'                                >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<value>1</value>'                                            >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '</property>'                                                 >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<property>'                                                  >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<name>dfs.permission</name>'                                 >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '<value>false</value>'                                        >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '</property>'                                                 >> $HADOOP_CONF_DIR/hdfs-site.xml
echo '</configuration>'                                            >> $HADOOP_CONF_DIR/hdfs-site.xml
print_task_completion

echo "[+] Configuring Map Reduce"
echo '<?xml version="1.0" encoding="UTF-8"?>'                      > $HADOOP_CONF_DIR/mapred-site.xml
echo '<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>' >> $HADOOP_CONF_DIR/mapred-site.xml
echo '<configuration>'                                             >> $HADOOP_CONF_DIR/mapred-site.xml
echo '<property>'                                                  >> $HADOOP_CONF_DIR/mapred-site.xml
echo '<name>mapreduce.framework.name</name>'                       >> $HADOOP_CONF_DIR/mapred-site.xml
echo '<value>yarn</value>'                                         >> $HADOOP_CONF_DIR/mapred-site.xml
echo '</property>'                                                 >> $HADOOP_CONF_DIR/mapred-site.xml
echo '</configuration>'                                            >> $HADOOP_CONF_DIR/mapred-site.xml
print_task_completion

echo "[+] Configuring YARN"
echo '<?xml version="1.0">'                                              > $HADOOP_CONF_DIR/yarn-site.xml
echo '<configuration>'                                                   >> $HADOOP_CONF_DIR/yarn-site.xml
echo '<property>'                                                        >> $HADOOP_CONF_DIR/yarn-site.xml
echo '<name>yarn.nodemanager.aux-services</name>'                        >> $HADOOP_CONF_DIR/yarn-site.xml
echo '<value>mapreduce_shuffle</value>'                                  >> $HADOOP_CONF_DIR/yarn-site.xml
echo '</property>'                                                       >> $HADOOP_CONF_DIR/yarn-site.xml
echo '<property>'                                                        >> $HADOOP_CONF_DIR/yarn-site.xml                     
echo '<name>yarn.nodemanager.auxservices.mapreduce.shuffle.class</name>' >> $HADOOP_CONF_DIR/yarn-site.xml 
echo '<value>org.apache.hadoop.mapred.ShuffleHandler</value>'            >> $HADOOP_CONF_DIR/yarn-site.xml
echo '</property>'                                                       >> $HADOOP_CONF_DIR/yarn-site.xml
echo '</configuration>'                                                  >> $HADOOP_CONF_DIR/yarn-site.xml
print_task_completion

hadoop namenode -format
