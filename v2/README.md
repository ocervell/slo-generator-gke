# SLO Generator GKE Deployment

This repository is an example deployment of slo-generator to GKE. It uses a
Cronjob to run slo-generator on a schedule, and mounts SLO configurations as a
ConfigMap object.

This allows to set up the SLO reporting pipeline on GKE directly.

## Build the Docker image
Clone the `slo-generator` repo:
```
git clone https://github.com/GoogleCloudPlatform/professional-services
```

Build the `slo-generator` image:
```
cd tools/slo-generator
gcloud builds submit --tag=gcr.io/<PROJECT_ID>/slo-generator --project=<PROJECT_ID>
```

## Deploy to GKE

### Quick deploy & updates
A script has been created to automate deployment / updates to GKE:
```
./deploy.sh
```

### Manual deploy & updates (kubectl)

Notes: The steps below are included in the `deploy.sh` script.

**Create / update a `ConfigMap` from the SLO configs:**
```
kubectl create configmap slos --from-file slos/ -o yaml --dry-run=client | kubectl apply -f -
```

**Create / update the `error-budget-policy` `ConfigMap`:**
```
kubectl create configmap config --from-file error_budget_policy.yaml -o yaml --dry-run=client | kubectl apply -f -
```

**Deploy the `slo-generator`'s `Cronjob`:**
```
kubectl apply -f app.yaml
```

## Service account IAM roles
In order to use `slo-generator` in GKE, you will need to update the GKE service account IAM roles.

#### Cloud Monitoring
To use the `slo-generator` with Cloud Monitoring (backend / exporter):

* `Stackdriver` backend:
  * `roles/monitoring.viewer` on the Stackdriver host project.


* `Stackdriver` exporter:
  * `roles/monitoring.metricWriter` on the Stackdriver host project.


* `StackdriverServiceMonitoring` backend:
  * `roles/monitoring.servicesEditor` on the Stackdriver host project.

#### BigQuery
To use the `slo-generator` with BigQuery (exporter only):

* `Bigquery` exporter:
  * `roles/bigquery.dataEditor` on the BigQuery dataset.

#### PubSub
To use the `slo-generator` with PubSub (exporter only):

* `Pubsub` exporter:
  * `roles/pubsub.publisher` on the PubSub topic.

## Run with Docker (local)

**Build the Docker image:**
```
git clone https://github.com/GoogleCloudPlatform/professional-services
cd tools/slo-generator
docker build -t slo-generator .
```

**Copy your service account credentials to the current folder:**
```
cp /path/to/credentials.json credentials.json
```

**Run Docker image:**
```
docker run -v /path/to/slo_generator_gke/v1:/app --env GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json slo-generator -f slos/
```
