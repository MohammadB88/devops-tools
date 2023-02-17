# **DevOps-Tools**
In this repository, I will gather information about the requirements and installation steps for devops tools like Prometheus, Grafana, Jenkins, ArgoCD and ....
I will also document how to lunch and reach these services on a Kubernetes Cluster.


# **Table of Content**
- [**DevOps-Tools**](#devops-tools)
- [**Table of Content**](#table-of-content)
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
- [**Infrastructure as Code (IaC)**](#infrastructure-as-code-iac)
  - [**Terraform and AWS**](#terraform-and-aws)
    - [**AWS LocalStack**](#aws-localstack)
  - [**Ansible**](#ansible)
  - [**Terraform and Ansible**](#terraform-and-ansible)

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

# **Infrastructure as Code (IaC)**
Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure using code instead of manual processes. With IaC, you can define and automate the configuration, deployment, and maintenance of your infrastructure as a set of declarative code that can be version-controlled, tested, and shared.

IaC provides several benefits, including:

  1. **Consistency and repeatability:** By using code to define your infrastructure, you can ensure that all instances of your infrastructure are identical, reducing the risk of human error and increasing the reliability of your infrastructure.

  2. **Efficiency and speed:** With IaC, you can provision infrastructure much faster and with less effort than manual processes. Changes can be made quickly and reliably, reducing the time to deploy and increasing agility.

  3. **Scalability:** IaC allows you to easily scale your infrastructure up or down based on demand. You can define your infrastructure as a set of templates or modules that can be reused and adapted to different environments.

  4. **Collaboration and sharing:** With IaC, infrastructure is defined as code that can be shared, reviewed, and version-controlled like any other code. This makes it easy for teams to collaborate on infrastructure development and maintenance.

In summary, IaC can improve the consistency, reliability, efficiency, and agility of your infrastructure management, and is particularly useful in modern, cloud-based environments where infrastructure is frequently updated and scaled.
## **Terraform and AWS**
Terraform is a powerful open-source IaC tool that enables you to create, manage and provision infrastructure resources across multiple cloud providers or on-premises data centers, using a declarative language. Terraform helps you to manage infrastructure in a consistent and repeatable way, with a version-controlled configuration.

With Terraform, you can create infrastructure resources such as virtual machines, networks, storage, and services, on cloud platforms such as Amazon Web Services, Microsoft Azure, Google Cloud Platform, and many others. Terraform provides a consistent and unified way to manage infrastructure resources, regardless of the underlying cloud provider or technology.

One of the main benefits of Terraform is that it enables you to define your infrastructure as code, which makes it easy to version-control and collaborate on infrastructure changes. Additionally, Terraform enables you to apply, destroy, and update infrastructure resources in a safe and repeatable way, minimizing the risk of human error.

First step is to install *AWS CLI* and then *terraform*, which are explained in [Installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [Install Terraform](https://developer.hashicorp.com/terraform/downloads), respectively. 

Then, setup [*Programmatic Access Keys*](https://www.middlewareinventory.com/blog/aws-cli-ec2/#install-cli) on AWS account and import it in the *AWS Congfig Profile* on local machine using *aws configure* command.

Now all are set to create an *EC2* instance with the help of *Terraform*:
[Create EC2 instance with Terraform](https://www.middlewareinventory.com/blog/terraform-aws-example-ec2/)

**AWS OFFERS AN ALTERNATIVE FOR AWS CLOUD, CALLED AWS LOCALSTACK.**
### **AWS LocalStack**
AWS LocalStack is an open-source tool that provides a fully functional local AWS cloud stack for testing and developing cloud applications offline. LocalStack is designed to replicate the behavior of the Amazon Web Services (AWS) cloud services API, allowing developers to test and develop their applications locally before deploying to the cloud.

With LocalStack, you can simulate a wide range of AWS cloud services, such as *AWS Lambda*, *Amazon S3*, *Amazon DynamoDB*, *Amazon SQS*, and more. This enables developers to test and develop cloud applications locally, without incurring the cost and latency of cloud resources.

LocalStack provides a simple and easy-to-use interface, which enables developers to test and deploy their applications quickly and efficiently. Additionally, LocalStack supports a wide range of programming languages and frameworks, making it accessible to developers from different backgrounds.

One of the main benefits of LocalStack is that it enables developers to test and develop their applications offline, which can reduce the cost and time associated with cloud development. With LocalStack, developers can test and refine their applications until they are ready for deployment, ensuring that their applications are robust and reliable.

Here is how to setup [AWS environment locally with AWS Localstack](https://medium.com/wearesinch/simulating-aws-environment-locally-with-aws-localstack-ad5a80413d71#:~:text=What%20is%20LocalStack%3F,the%20real%20AWS%20cloud%20environment.)

## **Ansible**
Ansible is an open-source configuration management tool that automates software provisioning, configuration management, and application deployment. With Ansible, you can easily manage and configure infrastructure and applications across multiple servers, cloud platforms, and network devices, using a simple, human-readable language.

Ansible provides a simple and powerful way to automate complex IT tasks, allowing you to manage infrastructure and deploy applications faster, more consistently, and with less effort. With Ansible, you can define infrastructure and application configurations as code, which makes it easy to version-control, test, and reuse configurations.

One of the main benefits of Ansible is its simplicity and ease of use. Ansible uses a simple syntax (yaml) and does not require any specialized coding skills, making it accessible to both developers and system administrators. Additionally, Ansible is agentless, meaning that it does not require any software to be installed on the target servers or devices, which makes it easy to manage large-scale infrastructure.

At the moment, I use Ansible to install *httpd/apache2* packages and copy some web page.

Ansible can be installed using python modules like *pip* and *venv*:

1. **Install Python and pip:** Ansible is written in Python, so you'll need to install Python and pip first. You can download and install the latest version of Python from the official Python website](https://www.python.org/downloads/) and pip should be included with your Python installation.

2. Create a virtual environment using venv: A virtual environment is a self-contained directory that contains a Python installation and other dependencies. It's a best practice to use a virtual environment when installing Ansible, to ensure that the required dependencies are isolated from your system Python. To create a virtual environment, open a terminal or command prompt and type:
  ````
  python3 -m venv ansible-venv
  ````
This will create a new virtual environment called "ansible-venv" in the current directory.

3. Activate the virtual environment: To activate the virtual environment, type:
  ````
  source ansible-venv/bin/activate
  ````
This will activate the virtual environment and modify your shell prompt to show the name of the virtual environment.

4. Install Ansible using pip: Now that the virtual environment is activated, you can use pip to install Ansible. To install the latest version of Ansible, type:
  ````
  pip install ansible
  ````
This will download and install the latest version of Ansible and any required dependencies.

5. Verify the installation: To verify that Ansible was installed correctly, type:
  ````
  ansible --version
  ````

6. Deactivate the virtual environment: To deactivate the virtual environment, type:
  ````
  deactivate
  ````
This will return your shell to the original state, without the virtual environment active.

Since I have installed Ansible using pip and the *venv* module, the configuration file is not set for ansible. 
The only remedy in a ***WSL Environment*** is to use `export ANSIBLE_CONFIG=./ansible.cfg` to set the correct ansible configuration file in the current *shell*. 

Here is a link to a very nice and clear description, why this method of installation on *WSL* would not work simply:
[Avoiding security risks with ansible.cfg in the current directory](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir)
And the websites that pointed me to the write answer:
[Cannot find neither ~/.ansible.cfg or etc/ansible](https://stackoverflow.com/questions/58970811/cannot-find-neither-ansible-cfg-or-etc-ansible)
[Ansible installed via pip3, but Ansible commands not found](https://superuser.com/questions/1635257/ansible-installed-via-pip3-but-ansible-commands-not-found)

## **Terraform and Ansible**
It is a challenging task to run Ansible after Terraform provisioned the infrastructure. However, it could be performed using the provisioner *local-exec*:
````
provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.RESOURCE_NAME.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.RESOURCE_NAME.public_ip}, --private-key ${var.private_key_path} simple_webapp.yml"
    working_dir = "WORK_DIR"
  }
````
The provisioner "remote-exec" makes sure that the created machine is reachable via *SSH*.
It is very well explained in this video [Terraform Ansible Integration | Terraform Ansible AWS Example](https://www.youtube.com/watch?v=QxgJlJgGA0E&t=353s).