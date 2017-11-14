#!/bin/bash -ex

# Create node images

lxc init hadoop-base-swarm edge-local-grid -p docker_privileged
lxc config set edge-local-grid limits.cpu 1
lxc config set edge-local-grid limits.memory 1024MB
lxc config device add edge-local-grid root disk pool=default path=/ size=16GB
lxc start edge-local-grid
sleep 15
lxc config device add edge-local-grid dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add edge-local-grid registrytmp disk source=$(realpath registry) path=/registry
lxc exec edge-local-grid -- docker run -v /registry:/certs -e SSL_SUBJECT=edge-local-grid paulczar/omgwtfssl
lxc exec edge-local-grid -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec edge-local-grid -- mkdir -p /etc/docker/certs.d/edge-local-grid:443/
lxc exec edge-local-grid -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-grid:443/ca.crt
lxc exec edge-local-grid -- cp /registry/key.pem /etc/docker/certs.d/edge-local-grid:443/client.key
lxc exec edge-local-grid -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-grid:443/client.cert
lxc exec edge-local-grid -- touch /.dockerenv
lxc exec edge-local-grid -- docker run -d -p 443:5000 --restart=always --name registry --env-file /registry/env -v /registry:/registry registry:2
lxc exec edge-local-grid -- make -C /docker
lxc exec edge-local-grid -- docker swarm init
lxc exec edge-local-grid -- docker run -d -p 9000:9000 --restart=always --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer:/data portainer/portainer

lxc init hadoop-base-swarm mt-local-grid -p docker_privileged
lxc config set mt-local-grid limits.cpu 2
lxc config set mt-local-grid limits.memory 8192MB
lxc config device add mt-local-grid root disk pool=default path=/ size=80GB
lxc start mt-local-grid
sleep 15
lxc config device add mt-local-grid dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add mt-local-grid registrytmp disk source=$(realpath registry) path=/registry
lxc exec mt-local-grid -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec mt-local-grid -- mkdir -p /etc/docker/certs.d/edge-local-grid:443/
lxc exec mt-local-grid -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-grid:443/ca.crt
lxc exec mt-local-grid -- cp /registry/key.pem /etc/docker/certs.d/edge-local-grid:443/client.key
lxc exec mt-local-grid -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-grid:443/client.cert
lxc exec mt-local-grid -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-grid -- docker swarm join-token manager --quiet`
lxc exec mt-local-grid -- docker swarm join --token ${JOIN_TOKEN} edge-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-namenode=true mt-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-resourcemanager=true mt-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-jobhistory=true mt-local-grid

lxc init hadoop-base-swarm ds-local-grid -p docker_privileged
lxc config set ds-local-grid limits.cpu 2
lxc config set ds-local-grid limits.memory 8192MB
lxc config device add ds-local-grid root disk pool=default path=/ size=80GB
lxc start ds-local-grid
sleep 15
lxc config device add ds-local-grid dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add ds-local-grid registrytmp disk source=$(realpath registry) path=/registry
lxc exec ds-local-grid -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec ds-local-grid -- mkdir -p /etc/docker/certs.d/edge-local-grid:443/
lxc exec ds-local-grid -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-grid:443/ca.crt
lxc exec ds-local-grid -- cp /registry/key.pem /etc/docker/certs.d/edge-local-grid:443/client.key
lxc exec ds-local-grid -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-grid:443/client.cert
lxc exec ds-local-grid -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-grid -- docker swarm join-token manager --quiet`
lxc exec ds-local-grid -- docker swarm join --token ${JOIN_TOKEN} edge-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-zeppelin=true ds-local-grid

lxc init hadoop-base-swarm data01-local-grid -p docker_privileged
lxc config set data01-local-grid limits.cpu 2
lxc config set data01-local-grid limits.memory 8192MB
lxc config set data01-local-grid limits.memory.swap false
lxc config device add data01-local-grid root disk pool=default path=/ size=120GB
lxc start data01-local-grid
sleep 15
lxc config device add data01-local-grid dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add data01-local-grid registrytmp disk source=$(realpath registry) path=/registry
lxc exec data01-local-grid -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec data01-local-grid -- mkdir -p /etc/docker/certs.d/edge-local-grid:443/
lxc exec data01-local-grid -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-grid:443/ca.crt
lxc exec data01-local-grid -- cp /registry/key.pem /etc/docker/certs.d/edge-local-grid:443/client.key
lxc exec data01-local-grid -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-grid:443/client.cert
lxc exec data01-local-grid -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-grid -- docker swarm join-token worker --quiet`
lxc exec data01-local-grid -- docker swarm join --token ${JOIN_TOKEN} edge-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-datanode=true data01-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-nodemanager=true data01-local-grid

lxc init hadoop-base-swarm data02-local-grid -p docker_privileged
lxc config set data02-local-grid limits.cpu 2
lxc config set data02-local-grid limits.memory 8192MB
lxc config set data02-local-grid limits.memory.swap false
lxc config device add data02-local-grid root disk pool=default path=/ size=120GB
lxc start data02-local-grid
sleep 15
lxc config device add data02-local-grid dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add data02-local-grid registrytmp disk source=$(realpath registry) path=/registry
lxc exec data02-local-grid -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec data02-local-grid -- mkdir -p /etc/docker/certs.d/edge-local-grid:443/
lxc exec data02-local-grid -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-grid:443/ca.crt
lxc exec data02-local-grid -- cp /registry/key.pem /etc/docker/certs.d/edge-local-grid:443/client.key
lxc exec data02-local-grid -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-grid:443/client.cert
lxc exec data02-local-grid -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-grid -- docker swarm join-token worker --quiet`
lxc exec data02-local-grid -- docker swarm join --token ${JOIN_TOKEN} edge-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-datanode=true data02-local-grid
lxc exec edge-local-grid -- docker node update --label-add role-nodemanager=true data02-local-grid

