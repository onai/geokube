#!/bin/bash

## Deletes clusters

# Usage:
# ./delete-clusters <zone-region>...
#
#
# Examples:
# ./delete-clusters us-west1-a us-east4-a
#
# Will delete cluster onai-distr-apps in both us-west1-a and us-east4-a


while [ $# -gt 0 ]; do
    gcloud container clusters delete --quiet --zone $1 onai-distr-apps || exit 1
    shift
done
