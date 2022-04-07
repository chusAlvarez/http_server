# http_server
A dead simple Ruby web server.
Serves on port 80.
/healthcheck path returns "OK"
All other paths return "Well, hello there!"

`$ ruby webserver.rb`

## Some considerations

"Highly available environment" and "tailor it to use a local instance of minikube" are mutually exclusive requirements, sorry :D

I have tailored the installation to run two instances of the service with a load balancer. In a more realistic environment (running in a cloud provider) I will also configure a kubernetes cluster with at least two zones. The helm templates need no change for it, terraform shoud be changed to include HA cluster definition. (and a cloud provider)


## infraestructure with terraform

Note: As it should be tunned to minikube, dont have a shared backend in the cloud
Note2: As this will run locally in minikube, I have define here the helmrelease. In a more realistic environment, I am more prone to keep separate infra stuff from the one related to the deployment configuration

# steps to launch



## kubernetes lauch:
`$ minikube start`

## helm server

## infraestructure apply:

`$ terraform init`
`$ terraform apply`

# TODO
- CD pipeline
- metrics
- Errors
- Logs