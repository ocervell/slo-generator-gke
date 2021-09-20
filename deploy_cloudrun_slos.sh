#!/bin/bash

echo "⭐ Getting Cloud Run service URL ..."
SERVICE_URL=`gcloud run services describe slo-generator --region=${REGION} --project=${PROJECT_ID} --format="value(status.address.url)"`

echo "⭐ Deploying SLOs to GCS ..."
for slo_path in slos/*; do
    echo "⭐ Testing ${slo_path} ..."
    curl -X POST -H "Content-Type: text/x-yaml" --data-binary @${slo_path} ${SERVICE_URL} || "Test of ${slo_path} failed" && exit 1
done;
