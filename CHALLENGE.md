## Thought process and solutions to issues as they came up

* I decided to prevent the definition of Kubernetes resources such as *namespace* and *service* on both the Terraform level and the Helm level (may lead to inconsistency): Changed Terraform code to dynamically load the names of the resources from Helm's *values.html* file, maintaining a single source of truth.  
* Initialization of bucket and its contents outside of any specific MinIO pod: Created a separate Job object for content initialization, which fetches the files and pushes them to the bucket. Made sure that the job runs after the creation of the MinIO deployment/service, otherwise the job fails because there's no access to the bucket.
* Created an index.html file to satisfy the demands of s3www, and to have it load the GIF file.
* Started out with static values for MinIO user/password, then for increased security, changed the password to be randomly generated and stored in a Secret object.
* Shared storage for all MinIO pods: Tried to balance functionality, scalability, and possible limitations of different storage systems. Evaluated Deployment, StatefulSet, different settings for PVC, individual storage, shared storage, different accessModes. Eventually decided on Deployment+shared storage+ReadOnlyMany.
* Issues with compatiblity with Prometheus's auto discovery: Caused by a labels discrepancy between the ServiceMonitor and the Prometheus configuration, as expected. Fixed by adding a custom label (*release: prometheus*) in the MinIO ServiceMonitor.
* Addressed scalability using HorizontalPodAutoscaler objects. Addressed high availability using PodDisruptionBudget objects, and a features such as RollingUpdate, readinessProbe/livenessProbe and podAntiAffinity in the Deployment objects.

## Concerns with the implementation

* Data security: Encryption of data at rest should be provided at the infrastructure/storage level.
* Network security: Limiting access to the HTTP endpoint should be configured at the infrastructure/networking level, or using NetworkPolicy Kubernetes objects (or both).
* For production use, the Terraform state file should be hosted on shared storage, such as an S3 bucket (possibly with a DynamoDB backend for locking, if AWS is used).
* MinIO uses both an API endpoint (TCP port 9000) and a web console endpoint (TCP port 9001). Only API access was necessary within the scope of the challenge, so I didn't expose the web console port at the deployment or the service level. These changes can be made if the web console is necessary.
* If the users need access to the MinIO credentials, the Terraform outputs should be configured to output the username/password, with the password's output configured as *sensitive = true*.
* The *application_url* Terraform output is configured to use the *kubernetes_service* object's *status[0].load_balancer[0].ingress[0].hostname* attribute, which may need to be adjusted for production.
* The content initialization job is configured to overwrite the files in the bucket with files that it fetches from the web. If this is not desired behavior, the job should be reconfigured. 
