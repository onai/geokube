#!/bin/bash

## Resizes deployments and then resizes clusters, thus deleting nodes

# Usage:
# ./rescale-clusters.sh <<node_name> <new_size> <zone>>..
#
# Example:
#
# ./rescale-clusters.sh 1 1 us-west1-a 1 1 us-east4-a
#
# Assuming you ran the example in run-this.sh, this will resize cluster of size
# 3 with 2 stellar nodes and 1 qBittorrent nodes in us-west1-a to 1 of each
# stellar and qBittorrent. Then, it will resize a cluster of size 3 with 1
# stellar node and 2 qBittorrent nodes in us-east4-a to 1 of each stellar and
# qBittorrent


while [ $# -gt 0 ]; do
   
    node_name=$1; shift
    new_size=$1; shift
    zone_cla=$1; shift

    old_size=`kubectl get deployment $node_name | awk '{ print $2 }' | sed '2q;d'`

    old_cluster_size=`gcloud container clusters list --zone $zone_cla | awk '{ print $7 }' | sed '2q;d'`

    kubectl scale deployment $node_name --replicas=$new_size


    # assuming old_size is always greater than new size
    new_size=$(( $old_cluster_size - $(($old_size-$new_size)) ))

    gcloud container clusters resize onai-distr-apps \
       --num-nodes $new_size \
       --node-pool default-pool \
       --zone $zone_cla

done
