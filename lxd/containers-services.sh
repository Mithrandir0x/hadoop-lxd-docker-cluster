#!/bin/bash -x

# Create node images

lxc exec edge-local-grid -- docker network create -d overlay vxlan-local-grid

lxc exec mt-local-grid -- mkdir -p /data/hadoop/tmp/dfs/name
lxc exec edge-local-grid -- docker service create \
    --name "namenode-mt-local-grid" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition none \
    --network vxlan-local-grid \
    --publish mode=host,target=50070,published=50070 \
    --publish mode=host,target=8020,published=8020 \
    --constraint "node.labels.role-namenode==true" \
    --env-file /docker/hadoop.env \
    --mount type=bind,source=/data/hadoop/tmp/dfs/name,target=/hadoop/tmp/dfs/name \
    edge-local-grid:443/local.grid/hdfs-namenode:2.8.1


lxc exec edge-local-grid -- docker service create \
    --name "resourcemanager-mt-local-grid" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition none \
    --network vxlan-local-grid \
    --publish mode=host,target=8088,published=8088 \
    --publish mode=host,target=8032,published=8032 \
    --publish mode=host,target=8030,published=8030 \
    --publish mode=host,target=8031,published=8031 \
    --publish mode=host,target=8033,published=8033 \
    --constraint "node.labels.role-resourcemanager == true" \
    --env-file /docker/hadoop.env \
    edge-local-grid:443/local.grid/yarn-resourcemanager:2.8.1


lxc exec edge-local-grid -- docker service create \
    --name "jobhistory-mt-local-grid" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition none \
    --network vxlan-local-grid \
    --publish mode=host,target=19888,published=19888 \
    --constraint "node.labels.role-jobhistory==true" \
    --env-file /docker/hadoop.env \
    edge-local-grid:443/local.grid/mapred-jobhistory:2.8.1


lxc exec edge-local-grid -- docker service create \
    --name "zeppelin-ds-local-grid" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition none \
    --network vxlan-local-grid \
    --publish mode=host,target=8080,published=18080 \
    --constraint "node.labels.role-zeppelin==true" \
    --env-file /docker/hadoop.env \
    edge-local-grid:443/local.grid/zeppelin:2.8.1


lxc exec edge-local-grid -- docker service create \
    --name "datanode-data02-local-grid" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition none \
    --network vxlan-local-grid \
    --publish mode=host,target=50010,published=50010 \
    --publish mode=host,target=50020,published=50020 \
    --publish mode=host,target=50075,published=50075 \
    --constraint "node.labels.role-datanode==true" \
    --replicas 2 \
    --env-file /docker/hadoop.env \
    edge-local-grid:443/local.grid/hdfs-datanode:2.8.1


lxc exec edge-local-grid -- docker service create \
    --name "nodemanager-data02-local-grid" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition none \
    --network vxlan-local-grid \
    --publish mode=host,target=8040,published=8040 \
    --publish mode=host,target=8042,published=8042 \
    --publish mode=host,target=45454,published=45454 \
    --constraint "node.labels.role-nodemanager==true" \
    --replicas 2 \
    --env-file /docker/hadoop.env \
    edge-local-grid:443/local.grid/yarn-nodemanager:2.8.1
