#!/bin/bash

set -x

lxc delete edge-local-grid --force

lxc delete mt-local-grid --force

lxc delete ds-local-grid --force

lxc delete data01-local-grid --force
lxc delete data02-local-grid --force

set +x