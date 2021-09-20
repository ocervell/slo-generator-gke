#!/bin/bash
kubectl create -n slo configmap slos --from-file slos/ -o yaml --dry-run=client | kubectl apply -f -
