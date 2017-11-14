#!/bin/bash -x

namedir="/hadoop/tmp/dfs/name"
if [ ! -d '/hadoop/tmp/dfs/name' ]; then
  echo "Creating namenode folder [/hadoop/tmp/dfs/name]"
  mkdir -p /hadoop/tmp/dfs/name
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

if [ "`ls -A $namedir`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  cat /etc/hostname
  cat /etc/hosts
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode