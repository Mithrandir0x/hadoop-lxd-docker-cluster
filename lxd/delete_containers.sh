#!/bin/bash

set -x

lxc delete edge-local-vm --force

lxc delete mt-local-vm --force

lxc delete ds-local-vm --force

lxc delete data01-local-vm --force
lxc delete data02-local-vm --force

set +x