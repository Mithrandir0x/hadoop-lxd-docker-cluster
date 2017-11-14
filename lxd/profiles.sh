#!/bin/bash -x

lxc profile delete docker_privileged
lxc profile copy docker docker_privileged
lxc profile set docker_privileged security.nesting true
lxc profile set docker_privileged security.privileged true
lxc profile set docker_privileged linux.kernel_modules overlay,nf_nat,ip_tables,ip6_tables,netlink_diag,br_netfilter,xt_conntrack,nf_conntrack,ip_vs,vxlan
lxc profile set docker_privileged raw.lxc lxc.aa_profile=unconfined
echo "Set profile docker_privileged"

