#!/bin/bash
kubectl create namespace slo || echo "SLO namespace already exist."
kubectl create -n slo configmap slos --from-file slos/ -o yaml --dry-run=client | kubectl apply -f -
kubectl create -n slo configmap config --from-file config.yaml -o yaml --dry-run=client | kubectl apply -f -
kubectl apply -n slo -f app.yaml
