# Managing Google Kubernetes Engine (GKE) clusters

This repo hosts scripts to manage GKE clusters in a project called gke on Onai's Google cloud.

We have two kinds of distributed applications: Stellar-core and qBittorrent right now. But, this will code will support any number of applications. Each app is deployed with Go API for GKE.

`run-this.sh` - Script to create clusters, and deploy applications on the clusters.

`rescale-clusters.sh` - Script to rescale applications and clusters to a smaller size.

`delete-clusters.sh` - Script to delete clusters in given zones.


Each of these scripts have documentation on usage with examples.


# Requirements

1. Go
2. gcloud configured to Onai's account: https://cloud.google.com/kubernetes-engine/docs/quickstart


# Distributed applications

To run a distributed application in our gke cluster, write a json file for deploying the application using this guide: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

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


## Gcloud logging

Stackdriver provides logging API for log monitoring on Google Cloud https://cloud.google.com/logging/. However, it's not free.
