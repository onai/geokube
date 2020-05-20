#!/bin/bash

## Dumps logs from all pods to the folder logs/. logs/ will be created if it doesn't exist
## Throws error if we can't get logs from a particular container
##

get_pods_output="`kubectl get pods`" || exit 1 # exits on fail

## Output of kubectl get pods for version below
#
#
# No cluster: `The connection to the server localhost:8080 was refused - did you specify the right host or port?. (Exit status 1)`
#
# Cluster exists but no applications deployed: No resources found. (Exit status 0)
#
# Cluster exists and applications deployed:
#
# NAME                                  READY   STATUS              RESTARTS   AGE
# stellar-us-west1-b-6dc95b8d89-qjj9j   1/1     Running             0          44s
# stellar-us-west1-b-6dc95b8d89-xzwph   1/1     Running             0          44s
# torrent-us-west1-b-5f8d54984b-4lsmh   0/1     ContainerCreating   0          44s
#
# In this example, stellar (an application) is launched and running, but torrent is launched but still in
# ContainerCreating (not ready)
#
#


pod_names_list="`echo "$get_pods_output" | awk '{ print $1 }' | tail -n+2`"

mkdir -p logs

for pod_name in $pod_names_list
do
    kubectl logs $pod_name > logs/$pod_name.log || { echo "failed to get logs from $pod_name" ; exit 1 ; }
done


# Sample Output for:
# 
# Kubernetes version: Client Version: version.Info{Major:"1", Minor:"15", GitVersion:"v1.15.0", GitCommit:"e8462b5b5dc2584fdcd18e6bcfe9f1e4d970a529", GitTreeState:"clean", BuildDate:"2019-06-19T16:40:16Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
#
# 
# Gcloud version:
# 
# Google Cloud SDK 254.0.0
# alpha 2019.07.15
# beta 2019.07.15
# bq 2.0.45
# core 2019.07.15
# gsutil 4.40
# kubectl 2019.07.15
# 
# Case 1: Kubernetes clusters not created
# Output: `The connection to the server localhost:8080 was refused - did you specify the right host or port?. (Exit status 1)`
#
# Case 2: Cluster exists but no applications deployed
# Output: No resources found. (Exit status 0)
#
# Case 3: Success
# Output: No output, but the log files are stored in the log/ directory. (Exit status 0)
#
# Case 4: Cluster running and application deployed but pod not ready
# Output: ```Error from server (BadRequest): container "stellar" in pod "stellar-us-west1-b-6dc95b8d89-qjj9j" is waiting to start: ContainerCreating
#         failed to get logs from stellar-us-west1-b-6dc95b8d89-qjj9j```. (Exit status 1)
# 
