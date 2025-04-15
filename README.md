# UP42 Cloud Engineer Challenge

This repo provides Terraform and Helm code that deploys an s3www/MinIO application which serves static files over HTTP.

## Install

To install the code as intended, please execute (from the *./terraform* directory): *terraform init && terraform apply [-auto-approve]* 

For debugging purposes, to install the Helm chart outside of Terraform (from the *./helm* directory): *helm install up42-release . -n up42-ns --create-namespace --debug*

## Terraform behind-the-scenes

Terraform is configured to use the Helm and Kubernetes providers. *~/.kube/config* is assumed to exist and to contain configuration that allows Kubernetes commands to make changes to the relevant Kubernetes system.

The Terraform code will run Helm to install the custom Helm chart. The Terraform outputs will include the HTTP endpoint to access (*application_url*) and the Kubernetes namespace where the objects will be deployed (*deployed_namespace*).

At the final stage, Terraform will self-test and attempt to access the HTTP endpoint and fetch the file to be served. It will fail (return exit code 1) if the self-test fails and will succeed (return exit code 0) if the self-test succeeds.

## Helm behind-the-scenes

The Helm code includes a *values.yaml* file, which contains all user-configurable settings. The templates for the chart are located in the *./helm/templates* directory and use the file naming convention *s3www-XXX.yaml* for s3www and *minio-XXX.yaml* for MinIO.

Helm chart will create the following Kubernetes objects:
* MinIO deployment and service, which will host the bucket and serve it to s3www (using TCP port 9000).
* A content initializer Job, which will create a temporary pod that will initialize the MinIO bucket and copy the relevant files to it.
* s3www deployment and service, which will serve the files from the MinIO bucket over HTTP via a LoadBalancer (using TCP port 8080 internally and TCP port 80 externally).
* HorizontalPodAutoscaler objects for both s3www and MinIO, to scale the deployments up and down dynamically, based on CPU and memory usage.
* PodDisruptionBudget objects for both s3www and MinIO to ensure high availability during disruptions.
* An object of type Secret to store MinIO credentials (the password is generated dynamically) and make them available to both MinIO, s3www and the content initializer Job.
* A PersistentVolumeClaim for the MinIO bucket to enable persistent storage that is shared by all MinIO pods.
* A ServiceMonitor for MinIO, to export metrics to Prometheus.
* A ServiceAccount for MinIO, to ensure a distinct identity for it to run under.
