#!/bin/bash

set -e

echo "⭐ Deploy SLO configmap(s) ..."
kubectl create -n slo configmap slos --from-file slos/ -o yaml --dry-run=client | kubectl apply -f -
