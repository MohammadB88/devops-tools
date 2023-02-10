# devops-tools
In this repository, I will gather information about the requirements and installation steps for devops tools like Prometheus, Grafana, Jenkins, ArgoCD and ....
I will also document how to lunch and reach these services on a Kubernetes Cluster.


# Table of Content
- [devops-tools](#devops-tools)
- [Table of Content](#table-of-content)
  - [**Helm**](#helm)
  - [**Monitoring Tools**](#monitoring-tools)
    - [**Prometheus and Grafana**](#prometheus-and-grafana)
      - [**Minikube**](#minikube)
  - [**Jenkins**](#jenkins)
  - [**JenkinsX**](#jenkinsx)
  - [**CircleCI**](#circleci)
  - [**ArgoCD**](#argocd)
  - [**GitHub Action**](#github-action)

## **Helm**
*Helm* is the package manager for Kubernetes resources. It helps with managing Kubernetes applications. The installation on different operating systems is straightforward as explained in the documentation [installing Helm](https://helm.sh/docs/intro/install/). For example, this is how it can be installed on Debian/Ubuntu:
```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

Helm Charts help to define, install, and upgrade even the most complex Kubernetes application. Charts are easy to create, version, share, and publish. For example, I will use them to install Prometheus and Grafana on my Minikube cluster, which is explained in the next section.

## **Monitoring Tools**
### **Prometheus and Grafana**
Using Prometheus Operator, I have deployed Prometheus and Grafana to monitor different cluster metrices. This article is very detailed:

https://computingforgeeks.com/setup-prometheus-and-grafana-on-kubernetes/

Every time, I will clone the latest version of the operator and deploy the Prometheus and Grafana. 
Current Version: ?? 01.02.2023

In order to connect to the Grafana UI, its the service should be exposed on a port on host VM as
```
kubectl --namespace monitoring port-forward svc/grafana HOSST_PORT:SVC_PORT  --address IP_VM 
```

The UI for Prometheus and Alertmanager can be accessed in the same way:

```
kubectl --namespace monitoring port-forward svc/prometheus-k8s HOSST_PORT:SVC_PORT  --address IP_VM 

kubectl --namespace monitoring port-forward svc/alertmanager-main HOSST_PORT:SVC_PORT  --address IP_VM 
```

#### **Minikube**
This method did not work out for an installation on Minikube. Hence, I have used helm, as explained in [Install Prometheus and Grafana in Minikube Using Helm](https://iamprabinav.in/install-prmotheus-and-grafana-in-minikube-using-helm/), to install and prepare the Prometheus and Grafana solutions.

First, add the Prometheus and Grafana charts should be added to the helm repo and update it:

````
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo add prometheus-community https://grafana.github.io/helm-charts

helm repo update
````

Then, install the tools easily in the preferred namespace:
```
helm install prometheus prometheus-community/prometheus --namespace NAMESPACE

helm install grafana grafana/grafana --namespace NAMESPACE
```

To access these services, it is possible to use the previously mentioned method, however, Minikube also offers a solution, which also uses the port-forwarding in the background. 
It suggests to expose the application through a new service as NodePort:

````
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-new --namespace NAMESPACE

kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-new --namespace NAMESPACE
````

and use Minikube native feature to accessible the monitoring applications:

````
minikube service prometheus-server-new --namespace NAMESPACE

minikube service grafana-new --namespace NAMESPACE
````

The secret for Grafana UI can be found by running this command:
````
 kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
 ````


One can also reach these services through a Load Balancer or change the service types to NodePort and also store the data on a PersistentVolume. However, I will focus at the moment on the functionality of the tools and leave these explorations for later.

## **Jenkins**

## **JenkinsX**

## **CircleCI**

## **ArgoCD**

## **GitHub Action**

[Introduction to GitHub Actions - Docker](https://docs.docker.com/build/ci/github-actions/)
[Build from Dockerfile in subdirectory](https://github.com/docker/build-push-action/issues/169)
[Github Actions to make changes to a file](https://github.com/orgs/community/discussions/26842)
[Build-Push-Action](https://github.com/docker/build-push-action#path-context)