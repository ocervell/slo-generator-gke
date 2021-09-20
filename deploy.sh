#!/bin/bash
kubectl create configmap slos --from-file slos/ -o yaml --dry-run=client | kubectl apply -f -
kubectl create configmap config --from-file config.yaml -o yaml --dry-run=client | kubectl apply -f -
kubectl apply -f app.yaml
