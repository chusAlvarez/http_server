# http_server
A dead simple Ruby web server.
Serves on port 80.
/healthcheck path returns "OK"
All other paths return "Well, hello there!"

`$ ruby webserver.rb`

# Some considerations

"Highly available environment" and "tailor it to use a local instance of minikube" are mutually exclusive requirements, sorry :D

I have tailored the installation to run two instances of the service with a load balancer. In a more realistic environment (running in a cloud provider) I will also configure a kubernetes cluster with at least two zones. The helm templates need no change for it, terraform shoud be changed to include HA cluster definition. (and a cloud provider)

# prerrequisites to install and run the full environment
- minikube
- terraform
- helm
- (optional but useful) docker
- (optional but useful) curl
- (to run the continous CD script) wget and jq

## infraestructure with terraform
Note: As it should be tunned to minikube, dont have a shared backend in the cloud
Note2: As this will run locally in minikube, I have define here only the namespace.  When working in a provider of course this will have also the kubenetes cluster setup, the buket with the terraform backend, permissions...

# steps to launch

## kubernetes lauch:
`$ minikube start`

## infraestructure apply:

`$ terraform init`
`$ terraform apply`

## helm install
`$ cd helm/adjust`
`$ helm install adjust -f values.yaml .`

## helm upgrade
`$ cd helm/adjust`
`$ helm upgrade adjust -f values.yaml .`

or, to upgrade with a given tag:

`$ helm upgrade adjust  -f values.yaml --set image.tag=<tag> .`

# CI pieline
The CI pipeline set the docker image with the http server. Any change in the root branch (main)  will trigger the docker build.

I have used circleci integration for this, the workflow is stored in .circleci/config.yml

# Connect with the service:

I have choose don't add an ingress. Ingress in minikube means add addons, edit local resolv.conf to point to minikube... find it too messy for a demo.

More easy and less work for me and for you is rely in the old port-forward functionality. To make full use to the load balancer:

`$ kubectl port-forward -n adjust service/adjust 8080:80 &`

You can test it with:
`$ curl http://localhost:8080/healthcheck --http0.9 `

# automated CD pipeline
- The last step, the deploy, is not full automated: it will need to be manually deployed using `helm upgrade adjust  -f values.yaml --set image.tag=<tag> .`

A simple bash script checking if a new image as been uploaded to the docker repo can grant this. An example is in scripts/cd-continous.sh

can be run with:

`$ ./cd-continous.sh <current tag> <helm chart absolute dir>`

It will check periodically if a new image is created, and install it with helm

It rely in the new tag will be numeric and higer than last, of course if a version tag is more advanced (n.n.n), the script will need some work to adapt to it.

# TODO
- metrics
- Errors
- Logs