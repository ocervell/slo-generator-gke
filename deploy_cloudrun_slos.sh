#!/bin/bash

echo "⭐ Getting Cloud Run service URL ..."
SERVICE_URL=`gcloud run services describe slo-generator --region=${REGION} --project=${PROJECT_ID} --format="value(status.address.url)"`

echo "⭐ Deploying SLOs to GCS ..."
for slo_path in slos/*; do
    slo_filename=$(basename -- "$slo_path")
    slo_name="${slo_filename%.*}"

    echo "⭐ Sending '${slo_path}' to GCS bucket '${BUCKET_NAME}' ..."
    gsutil cp ${slo_path} gs://${BUCKET_NAME}/

    echo "⭐ Creating Cloud Scheduler job '${slo_name}' ..."
    gcloud scheduler jobs create http ${slo_name} --schedule="* * * * */1" \
    --uri=${SERVICE_URL} \
    --message-body="gs://${BUCKET_NAME}/${slo_path}" \
    --project=${PROJECT_ID} || echo "Scheduler job '${slo_name}' already exist."
done;
