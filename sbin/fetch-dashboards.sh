#!/usr/bin/env bash

###
# Script to export your grafana config for sharing with others.  Right now we
# manually code in the list of dashboards but in the future we could use search
# with tags to export only 'shared' dashboards.
#
# We pipe the JSON through 'jq' to get pretty JSON for easier debug and sharing.

hostname=${1}
token=${2}

if [ "${hostname}" = "" ] || [ "${token}" = "" ]; then
    echo "SYNTAX ${0} hostname token" > /dev/stderr
    exit 1
fi

set -e

DASHBOARDS="
cassandra
cassandra-cache
cassandra-compactions
cassandra-coordinator-requests
cassandra-cqlstatements
cassandra-entropy
cassandra-thread-pools
elasticsearch
instances
instances-network
load-balancer
load-balancer-backends
prometheus-2-0
"

for dashboard in ${DASHBOARDS}; do

    echo "Fetching JSON for dashboard: ${dashboard}"
    curl -s -H "Authorization: Bearer ${token}" https://${hostname}/api/dashboards/db/${dashboard} | jq . > dashboards/${dashboard}.json

done
