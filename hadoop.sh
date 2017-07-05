#!/bin/bash
/usr/sbin/sshd

cat /hosts > /etc/hosts

rm -rf /tmp/*

if [ -d "/hadoop/logs" ]
then
  rm -rf /hadoop/logs/*
fi

if [ ! -d "/data/dfs/name" ] && [ $HOSTNAME == "master" ]
then
  $HADOOP_PREFIX/bin/hdfs namenode -format
fi

if [ $HOSTNAME == "master" ]
then
  $HADOOP_PREFIX/sbin/start-dfs.sh
  $HADOOP_PREFIX/sbin/start-yarn.sh
  $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver
fi

if [ "$1" == "-bash" ]
then
  bash
fi
