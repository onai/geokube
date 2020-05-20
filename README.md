This tool allows one to manage arbitrary distributed applications through Kubernetes on the cloud and perform chaos testing. The repository also includes an instance that allows measurement of network latencies between GKE locations and IP addresses around the world.

# Table Of Contents

1. [Background](#Background)
2. [Requirements](#Requirements)
3. [Managing GKE clusters](#Managing-GKE-clusters)
4. [Distributed Applications](#Distributed-Applications)
5. [Logging](#Logging)
6. [Network Latency](#network-latency)

# Background
We constructed a tool that allows us to run any application across a large real-world network (automation provided for Google Cloud), with given geographic distribution and configuration, and then arbitrarily “break” it by taking nodes offline. The tool allows any combination of Docker images to be distributed to data centers as specified. We can then pull logs to view metrics like network traffic, etc.. We tested this with various commands.

# Requirements

1. Go: https://golang.org/dl/
2. To use Google Cloud, Gcloud configured to your account: Follow instructions from https://cloud.google.com/kubernetes-engine/docs/quickstart

# Managing GKE clusters

This repository hosts scripts to manage GKE clusters in your project on Google Cloud. Each app is deployed with Go API for GKE.

## Creating and deploying applications to clusters

Usage:
`./run-this.sh <<M> <N_node-1_deploys> <N_node-2_deploys>...<N_node-M_deploys> <zone>>..`

M - Number of apps in each zone

N - cluster size

N_node-i_deploys - name of .json/.yaml deployment file


Example:

```
./run-this.sh 2 2 stellar_deployment.json 1 torrent_deployment.json us-west1-a 1 2 stellar_deployment.json us-east4-a
```

This will create a cluster of size 3 with 2 stellar nodes and 1 qBittorrent nodes in us-west1-a, and a cluster of size 2 with 2 stellar nodes in us-east4-a

## Rescaling applications and clusters to a smaller size. This script simulates the “breaking” 

Usage:
`./rescale-clusters.sh <<node_name> <new_size> <zone>>..`

node_name - Node name as given

new_size - New size of the cluster

zone - In what zone to rescale


Example: This will resize a cluster of stellar nodes in us-east4-a to a new size of one node in the cluster.
```
./rescale-clusters.sh stellar-us-east4-a 1 us-east4-a
```


## Delete clusters in given zones.


Usage:
`./delete-clusters <zone-region>...`

zone - In what zone to delete cluster

Example: This will delete cluster onai-distr-apps in both us-west1-a and us-east4-a
```
./delete-clusters us-west1-a us-east4-a

```

# Distributed applications

To run a distributed application in cluster, write a Kubernetes json file for deploying the application using this guide: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

# Services

To start services for each application, run:
`kubectl apply -f <service_file>`

e.g. `kubectl apply -f stellar-service.yaml` to start stellar service

Specification for services is given here: https://kubernetes.io/docs/concepts/services-networking/service/


# Logging

## Pod-level application logs

`kubectl logs` can be used to pull the logs that the application outputs in the container. To get a list of pods, you can run `kubectl get pods`.

Pick your pod and get the full log by running `kubectl logs <pod-name>`.


## Node level logs
Node level system logs can be written to stdout by mounting the `/var/log` directory into the container (or having another container just for logging) and redirecting to stdout. `kubectl logs` can be used to get the system logs of the node.

Nodes can also run cAdvisor containers https://github.com/google/cadvisor to collect CPU, memory, filesystem and network usage statistics.

# Network Latency
Besides the examples mentioned above, see this example for measuring latencies: [Another Example](network-latency/)
