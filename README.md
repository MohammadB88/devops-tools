# DevOps-Tools
In this repository, I will gather information about the requirements and installation steps for devops tools like Prometheus, Grafana, Jenkins, ArgoCD and ....
I will also document how to lunch and reach these services on a Kubernetes Cluster.


# Table of Content
- [DevOps-Tools](#devops-tools)
- [Table of Content](#table-of-content)
  - [**Helm**](#helm)
  - [**Monitoring**](#monitoring)
    - [**Kubernetes monitoring**](#kubernetes-monitoring)
    - [**Kubernetes APM**](#kubernetes-apm)
    - [**Kubernetes Monitoring Tools**](#kubernetes-monitoring-tools)
    - [**Prometheus and Grafana**](#prometheus-and-grafana)
      - [**Minikube**](#minikube)
  - [**Jenkins**](#jenkins)
  - [**JenkinsX**](#jenkinsx)
  - [**CircleCI**](#circleci)
  - [**ArgoCD**](#argocd)
  - [**GitHub Action**](#github-action)
- [Infrastructure as Code (IaC)](#infrastructure-as-code-iac)
  - [**Terraform and AWS**](#terraform-and-aws)
  - [*Ansible*](#ansible)

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

## **Monitoring**
Kubernetes monitoring is a type of reporting that helps identify problems in a Kubernetes cluster and implement proactive cluster management strategies. Kubernetes cluster monitoring tracks cluster resource utilization, including storage, CPU and memory. This eases containerized infrastructure management. 

### **Kubernetes monitoring**
Find important Kubernetes monitoring metrics using the Kubernetes Metrics Server. Kubernetes Metrics Server collects and aggregates data from the kubelet on each node. Consider some of these key Kubernetes metrics:

  - **API request latency**, the lower the better, measured in milliseconds
  - **Cluster state metrics**, including the availability and health of pods
  - **CPU utilization** in relation to per pod CPU resource allocation
  - **Disk utilization** including lack of space for file system and index nodes
  - **Memory utilization** at the node and pod levels
  - **Node status**, including disk or processor overload, memory, network availability, and readiness
  - **Pod availability** (unavailable pods may indicate poorly designed readiness probes or configuration issues)


While *Kubernetes monitoring* focuses on the performance of the cluster itself, *Kubernetes APM* focuses on monitoring the performance of the applications running in the Kubernetes cluster, 

Monitoring the Kubernetes cluster involves tracking the control plane/API server and the worker nodes. The control plane is where the Kubernetes API runs along with the cluster store (etcd), controller manager and controllers (which control the state of your cluster), and the scheduler (how and where pods run). And it’s where you’ll find the pods, including the kubelet (agent), kube-proxy (networking), DNS, and the container runtime. You also need to monitor the underlying infrastructure, which can mean two to three control planes and three to four worker nodes in production.

Monitoring the application means understanding how it’s performing in a pod, which holds the containers. You need to monitor the binary running in the pod, because the pod might be running even if the application isn’t. As we stated at the outset, the problem is that Kubernetes doesn’t provide an easy way to monitor application data like it does for the rest of the cluster components.

You should also monitor the resource usage of applications inside the Kubernetes cluster. Make sure to limit each application’s resources (like CPU and memory) so that one application doesn’t use up all the resources on the node and cause issues for the other applications running on the same node.

### **Kubernetes APM**
When monitoring a Kubernetes cluster, there are some key metrics to know for Kubernetes APM. Some of the key metrics your team can use to detect issues that affect application performance and user experience include:

  - **Request rate:** This metric allows you to visualize the number of requests users make to the application or service per unit of time. This makes it easy to identify spikes in user traffic, which in turn helps engineers plan for resource scaling at times of high and low demand.
  - **Response time:** This metric measures the average response time of the application. When this value exceeds a certain threshold, lags could impact the user experience, hence the importance of monitoring it.
  - **Error rate:** This tracks how many errors occur in a certain amount of time, which makes it a useful metric for ensuring compliance with service level agreements (SLAs).
  - Memory usage. This metric provides insight into the memory usage of the application or service. It’s useful for setting alerts and tracking application optimizations.
  - **CPU usage:** Like memory usage, this metric allows for evaluation of the resources consumed by the application or service. You can use this information in many ways, including planning the resources needed in the cluster during peak hours and detecting higher than usual CPU usage.
  - **Persistent storage usage:** This metric also has to do with the resources that the application needs, but from the viewpoint of permanent storage. In Kubernetes, managing persistent storage is just as important as managing CPU and memory usage, so it’s crucial to include this metric in your analyses.
  - **Uptime:** Along with error rate, this metric is tremendously useful to keep an eye on SLAs since it allows you to calculate the percentage of time that the application remains online.

### **Kubernetes Monitoring Tools**
Kubernetes users often use open source tools that are deployed inside Kubernetes as monitoring solutions. These include Heapster/InfluxDB/Grafana and Prometheus/Grafana. It’s also possible to conduct Kubernetes monitoring with ELK Stack or a hosted solution (Heapster/ELK). Finally, proprietary APM solutions that offer Kubernetes monitoring are also on the market.

Here are some of the more common tools for Kubernetes monitoring.

Prometheus metrics. Prometheus is an open source system created by the Cloud Native Computing Foundation (CNCF). The Prometheus server collects data from nodes, pods, and jobs, and other Kubernetes health metrics after installing data exporter pods on each node in the cluster. It saves collected time-series data into a database, and generates alerts automatically based on preset conditions.

The Prometheus dashboard is limited, but users enhance it with external visualization tools such as Grafana, which enables customized and sophisticated debugging, inquiries, and reporting using the Prometheus database. Prometheus supports importing data from many third-party databases.

Kubernetes dashboard. The Kubernetes dashboard is a simple web interface for debugging containerized applications and managing cluster resources. The Kubernetes dashboard provides a rundown of all defined storage classes and all cluster namespaces, and a simple overview of resources, both on individual nodes and cluster-wide.

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

There is a [Grafana Dashboards Library](https://grafana.com/grafana/dashboards/?orderBy=name&direction=asc), which helps to build and explor Grafana capabilities as well as learn different metrices and how to work use them. Here, are the links to some of the professional looking dashboards:

- [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
- [1 K8S for Prometheus Dashboard](https://grafana.com/grafana/dashboards/15661-1-k8s-for-prometheus-dashboard-20211010/?tab=revisions)
- [Kubernetes apiserver](https://grafana.com/grafana/dashboards/12006-kubernetes-apiserver/?tab=revisions)
- [NGINX Ingress controller](https://grafana.com/grafana/dashboards/9614-nginx-ingress-controller/?tab=revisions)
- []()
- []()

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

# Infrastructure as Code (IaC)
## **Terraform and AWS**
Terraform is a powerful tool to create infrastructure specially on cloud providers like AWS. First step is to install *AWS CLI* and then *terraform*, which are explained in [Installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [Install Terraform](https://developer.hashicorp.com/terraform/downloads), respectively. 

The next step is to setup [*Programmatic Access Keys*](https://www.middlewareinventory.com/blog/aws-cli-ec2/#install-cli) on AWS account and import it in the *AWS Congfig Profile* on local machine using *aws configure* command.

Now all are set to create an *EC2* instance with the help of *Terraform*:
[Create EC2 instance with Terraform](https://www.middlewareinventory.com/blog/terraform-aws-example-ec2/)

***AWS OFFERS AN ALTERNATIVE FOR AWS CLOUD, CALLED AWS LOCALSTACK.**

Here is how to setup [AWS environment locally with AWS Localstack](https://medium.com/wearesinch/simulating-aws-environment-locally-with-aws-localstack-ad5a80413d71#:~:text=What%20is%20LocalStack%3F,the%20real%20AWS%20cloud%20environment.)

## *Ansible*
At the moment I use Ansible to install *httpd/apache2* packages and copy some web page.
