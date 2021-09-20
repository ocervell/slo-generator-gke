#!/bin/bash

set -e

echo "⭐ Create namespace 'slo' ..."
kubectl create namespace slo || echo "SLO namespace already exist."

echo "⭐ Create slo-generator configmap 'config.yaml' ..."
kubectl create -n slo configmap config --from-file config.yaml -o yaml --dry-run=client | kubectl apply -f -

echo "⭐ Deploy slo-generator cronjob ..."
kubectl apply -n slo -f app.yaml
