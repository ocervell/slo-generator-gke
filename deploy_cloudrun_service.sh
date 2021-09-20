#!/bin/sh

set -e

echo "⭐ Creating GCS bucket to hold SLO configurations ..."
gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME} || echo "Bucket ${BUCKET_NAME} already created."

echo "⭐ Sending slo-generator config to GCS ..."
gsutil cp config.yaml gs://${BUCKET_NAME}/config.yaml

echo "⭐ Deploying Cloud Run service ..."
gcloud run deploy slo-generator \
--image gcr.io/slo-generator-ci-a2b4/slo-generator:2.0.0-rc3 \
--region=europe-west1 \
--platform managed \
--set-env-vars CONFIG_PATH=gs://${PROJECT_ID}/config.yaml \
--command="slo-generator" \
--args=api \
--args=--signature-type="http" \
--min-instances 1 \
--allow-unauthenticated \
--project=${PROJECT_ID}

SERVICE_URL=`gcloud run services describe slo-generator --region=${REGION} --project=${PROJECT_ID} --format="value(status.address.url)"`
echo "⭐ Cloud Run service URL: ${SERVICE_URL}"
