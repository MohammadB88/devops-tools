# devops-tools
In this repository, I will gather information about the requirements and installation steps for devops tools like Prometheus, Grafana, Jenkins, ArgoCD and ....
I will also document how to lunch and reach these services on a Kubernetes Cluster.


# Table of Content
- [devops-tools](#devops-tools)
- [Table of Content](#table-of-content)
  - [Prometheus and Grafana](#prometheus-and-grafana)
  - [Jenkins](#jenkins)
  - [JenkinsX](#jenkinsx)
  - [CircleCI](#circleci)
  - [ArgoCD](#argocd)
  - [GitHub Action](#github-action)


## Prometheus and Grafana
Using  Prometheus Operator, I have deplyod Prometheus and Grafana to monitor different cluster metrices. This article is very detailed:

https://computingforgeeks.com/setup-prometheus-and-grafana-on-kubernetes/

Every time, I will clone the latest version of the operator and deploy the prometheus and grafana. 
Current Version: ?? 01.02.2023

After the installation and in order to connect to the Grafana UI, its the service should be exposed on a port of a host VM as
```
kubectl --namespace monitoring port-forward svc/grafana HOSST_PORT:SVC_PORT  --address IP_VM 
```

The UI for Prometheus and Alertmanager can be accessed in the same way:

```
kubectl --namespace monitoring port-forward svc/prometheus-k8s HOSST_PORT:SVC_PORT  --address IP_VM 

kubectl --namespace monitoring port-forward svc/alertmanager-main HOSST_PORT:SVC_PORT  --address IP_VM 
```

One can also reach these services through a Load Balancer or change the service types to NodePort and also store the data on a PersistentVolume. However, I will focus at the moment on the functionality a of the tools and leave these explorations for later.

## Jenkins

## JenkinsX

## CircleCI

## ArgoCD

## GitHub Action

[Introduction to GitHub Actions - Docker](https://docs.docker.com/build/ci/github-actions/)
[Build from Dockerfile in subdirectory](https://github.com/docker/build-push-action/issues/169)
[Github Actions to make changes to a file](https://github.com/orgs/community/discussions/26842)
[Build-Push-Action](https://github.com/docker/build-push-action#path-context)