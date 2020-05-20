#!/bin/bash

for location in us-west2-a southamerica-east1-a europe-west2-a asia-south1-a australia-southeast1-a
do
    ./run-this.sh 1 1 ping-deployment.json $location

    sleep 20m
    
    ./pull_logs.sh
    
    sleep 5m

    ./delete-clusters.sh $location

done
