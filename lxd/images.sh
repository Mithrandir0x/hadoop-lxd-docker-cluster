#!/bin/bash

set -x

lxc init images:ubuntu/xenial hadoop-base-swarm -p default -p docker_privileged 
lxc start hadoop-base-swarm
sleep 15
set -e

set +e
lxc file push docker-install.sh hadoop-base-swarm/tmp/docker-install.sh
lxc exec hadoop-base-swarm -- bash /tmp/docker-install.sh
sleep 15
lxc stop hadoop-base-swarm
lxc publish hadoop-base-swarm --alias hadoop-base-swarm
lxc delete hadoop-base-swarm


set +x