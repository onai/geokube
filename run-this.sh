#!/bin/bash

## Creates GKE (Google Kubernetes Engine) clusters in multiple zones, deploys
## application containers in the nodes and starts respective services
## on the deployed nodes

# Usage:
# ./run-this.sh <<M> <N_node-1_deploys> <N_node-2_deploys>...<N_node-M_deploys> <zone>>..
#
# Example:
#
# ./run-this.sh 2 2 stellar_deployment.json 1 torrent_deployment.json us-west1-a 1 2 stellar_deployment.json us-east4-a
#
# Will create a cluster of size 3 with 2 stellar nodes and 1 qBittorrent nodes
# in us-west1-a, and a cluster of size 2 with 2 stellar nodes in us-east4-a

# Note: If you want to create a cluster in every zone of a region, don't
#       specify the zone e.g. us-west1 instead of us-west1-a

# Compile go app
go build -o ./app
      
while [ $# -gt 0 ]; do
    M=$1; shift
    app_array=()
   
    num_app=$M
    total_nodes=0
    while [ $num_app -gt 0 ]; do
        total_nodes=$(($total_nodes + $1))
        app_array+=($1 $2 ) ; shift ; shift
        num_app=$((num_app-1))
    done

    # zone
    app_array+=($1) ; shift


    #stellar_nodes=$1; shift
    #torrent_nodes=$1; shift
    zone_cla=${app_array[-1]}

    #echo "${app_array[-1]}"
    N=$total_nodes

    echo "Creating a $N node cluster in $zone_cla"

    #continue
    gcloud container clusters create onai-distr-apps \
       --num-nodes $N \
       --enable-basic-auth \
       --issue-client-certificate \
       --zone $zone_cla

    echo "Deploying apps in $zone_cla"

    # Deploy
    echo "./app $M ${app_array[*]}"
    ./app $M ${app_array[*]}
done


# Start services
#kubectl apply -f stellar-service.yaml
#kubectl apply -f qtor-service.yaml
