#!/bin/bash -ex

# Create node images

lxc init hadoop-base-swarm edge-local-vm -p default -p docker_privileged
lxc config set edge-local-vm limits.cpu 1
lxc config set edge-local-vm limits.memory 1024MB
lxc config device add edge-local-vm root disk pool=default path=/ size=16GB
lxc start edge-local-vm
sleep 15
lxc config device add edge-local-vm dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add edge-local-vm registrytmp disk source=$(realpath registry) path=/registry
lxc exec edge-local-vm -- docker run -v /registry:/certs -e SSL_SUBJECT=edge-local-vm paulczar/omgwtfssl
lxc exec edge-local-vm -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec edge-local-vm -- mkdir -p /etc/docker/certs.d/edge-local-vm:443/
lxc exec edge-local-vm -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-vm:443/ca.crt
lxc exec edge-local-vm -- cp /registry/key.pem /etc/docker/certs.d/edge-local-vm:443/client.key
lxc exec edge-local-vm -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-vm:443/client.cert
lxc exec edge-local-vm -- touch /.dockerenv
lxc exec edge-local-vm -- docker run -d -p 443:5000 --restart=always --name registry --env-file /registry/env -v /registry:/registry registry:2
lxc exec edge-local-vm -- make -C /docker
lxc exec edge-local-vm -- docker swarm init
lxc exec edge-local-vm -- docker run -d -p 9000:9000 --restart=always --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer:/data portainer/portainer

lxc init hadoop-base-swarm mt-local-vm -p default -p docker_privileged
lxc config set mt-local-vm limits.cpu 2
lxc config set mt-local-vm limits.memory 8192MB
lxc config device add mt-local-vm root disk pool=default path=/ size=80GB
lxc start mt-local-vm
sleep 15
lxc config device add mt-local-vm dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add mt-local-vm registrytmp disk source=$(realpath registry) path=/registry
lxc exec mt-local-vm -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec mt-local-vm -- mkdir -p /etc/docker/certs.d/edge-local-vm:443/
lxc exec mt-local-vm -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-vm:443/ca.crt
lxc exec mt-local-vm -- cp /registry/key.pem /etc/docker/certs.d/edge-local-vm:443/client.key
lxc exec mt-local-vm -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-vm:443/client.cert
lxc exec mt-local-vm -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-vm -- docker swarm join-token manager --quiet`
lxc exec mt-local-vm -- docker swarm join --token ${JOIN_TOKEN} edge-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-namenode=true mt-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-resourcemanager=true mt-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-jobhistory=true mt-local-vm

lxc init hadoop-base-swarm ds-local-vm -p default -p docker_privileged
lxc config set ds-local-vm limits.cpu 2
lxc config set ds-local-vm limits.memory 8192MB
lxc config device add ds-local-vm root disk pool=default path=/ size=80GB
lxc start ds-local-vm
sleep 15
lxc config device add ds-local-vm dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add ds-local-vm registrytmp disk source=$(realpath registry) path=/registry
lxc exec ds-local-vm -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec ds-local-vm -- mkdir -p /etc/docker/certs.d/edge-local-vm:443/
lxc exec ds-local-vm -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-vm:443/ca.crt
lxc exec ds-local-vm -- cp /registry/key.pem /etc/docker/certs.d/edge-local-vm:443/client.key
lxc exec ds-local-vm -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-vm:443/client.cert
lxc exec ds-local-vm -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-vm -- docker swarm join-token manager --quiet`
lxc exec ds-local-vm -- docker swarm join --token ${JOIN_TOKEN} edge-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-zeppelin=true ds-local-vm

lxc init hadoop-base-swarm data01-local-vm -p default -p docker_privileged
lxc config set data01-local-vm limits.cpu 2
lxc config set data01-local-vm limits.memory 8192MB
lxc config set data01-local-vm limits.memory.swap false
lxc config device add data01-local-vm root disk pool=default path=/ size=120GB
lxc start data01-local-vm
sleep 15
lxc config device add data01-local-vm dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add data01-local-vm registrytmp disk source=$(realpath registry) path=/registry
lxc exec data01-local-vm -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec data01-local-vm -- mkdir -p /etc/docker/certs.d/edge-local-vm:443/
lxc exec data01-local-vm -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-vm:443/ca.crt
lxc exec data01-local-vm -- cp /registry/key.pem /etc/docker/certs.d/edge-local-vm:443/client.key
lxc exec data01-local-vm -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-vm:443/client.cert
lxc exec data01-local-vm -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-vm -- docker swarm join-token worker --quiet`
lxc exec data01-local-vm -- docker swarm join --token ${JOIN_TOKEN} edge-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-datanode=true data01-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-nodemanager=true data01-local-vm

lxc init hadoop-base-swarm data02-local-vm -p default -p docker_privileged
lxc config set data02-local-vm limits.cpu 2
lxc config set data02-local-vm limits.memory 8192MB
lxc config set data02-local-vm limits.memory.swap false
lxc config device add data02-local-vm root disk pool=default path=/ size=120GB
lxc start data02-local-vm
sleep 15
lxc config device add data02-local-vm dockertmp disk source=$(realpath ./../docker) path=/docker
lxc config device add data02-local-vm registrytmp disk source=$(realpath registry) path=/registry
lxc exec data02-local-vm -- cp /registry/cert.pem /etc/ssl/certs/
lxc exec data02-local-vm -- mkdir -p /etc/docker/certs.d/edge-local-vm:443/
lxc exec data02-local-vm -- cp /registry/ca.pem /etc/docker/certs.d/edge-local-vm:443/ca.crt
lxc exec data02-local-vm -- cp /registry/key.pem /etc/docker/certs.d/edge-local-vm:443/client.key
lxc exec data02-local-vm -- cp /registry/cert.pem /etc/docker/certs.d/edge-local-vm:443/client.cert
lxc exec data02-local-vm -- touch /.dockerenv
JOIN_TOKEN=`lxc exec edge-local-vm -- docker swarm join-token worker --quiet`
lxc exec data02-local-vm -- docker swarm join --token ${JOIN_TOKEN} edge-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-datanode=true data02-local-vm
lxc exec edge-local-vm -- docker node update --label-add role-nodemanager=true data02-local-vm

