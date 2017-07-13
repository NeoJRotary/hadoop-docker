#!/bin/bash
if [ "$MODE" == "ENV" ]; then
  IFS=',' read -ra hostList <<< "$HOSTS"
  slaves=""
  for h in "${hostList[@]}"; do
    slaves=$slaves$h$'\n'
  done
  echo "$slaves" > $HADOOP_CONF_DIR/slaves
  sed -i '$ d' $HADOOP_CONF_DIR/slaves
else
  cat /hosts > /etc/hosts
  IFS=' ' read -ra hostList <<< $(<$HADOOP_CONF_DIR/slaves)
fi

if [ "$DNSNAMESERVER" != "" ]; then
  sed -i 's/DNSNAMESERVER/'"$DNSNAMESERVER"'/g' $HADOOP_CONF_DIR/hdfs-site.xml
  sed -i 's/DNSNAMESERVER/'"$DNSNAMESERVER"'/g' $HADOOP_CONF_DIR/mapred-site.xml
else 
  sed -i 's/DNSNAMESERVER/default/g' $HADOOP_CONF_DIR/hdfs-site.xml
  sed -i 's/DNSNAMESERVER/default/g' $HADOOP_CONF_DIR/mapred-site.xml
fi

sed -i 's/NAMENODE/'"${hostList[0]}"'/g' $HADOOP_CONF_DIR/core-site.xml
sed -i 's/NAMENODE/'"${hostList[0]}"'/g' $HADOOP_CONF_DIR/hdfs-site.xml
sed -i 's/NAMENODE/'"${hostList[0]}"'/g' $HADOOP_CONF_DIR/yarn-site.xml
sed -i 's/SECONDNODE/'"${hostList[1]}"'/g' $HADOOP_CONF_DIR/hdfs-site.xml

rm -rf /tmp/*

if [ -d "/hadoop/logs" ]; then
  rm -rf /hadoop/logs/*
fi

/usr/sbin/sshd

if [ ! -d "/data/dfs/name" ] && [ "$ROLE" == "namenode" ]; then
  $HADOOP_PREFIX/bin/hdfs namenode -format
fi

if [ "$ROLE" == "namenode" ]; then
  $HADOOP_PREFIX/sbin/start-dfs.sh
  $HADOOP_PREFIX/sbin/start-yarn.sh
  $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver
fi

if [ "$1" == "-bash" ]; then
  bash
elif [ "$1" == "-sleep" ]; then
  while true
  do
	  sleep 24h
  done
fi