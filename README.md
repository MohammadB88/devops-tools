# devops-tools

Using  Prometheus Operator, I have deplyod Prometheus and Grafana to monitor different cluster metrices. This article is very detailed:

https://computingforgeeks.com/setup-prometheus-and-grafana-on-kubernetes/

Every time, I will clone the latest version of the operator and deploy the prometheus and grafana. 
Current Version: ?? 01.02.2023

## Prometheus and Grafana
After the installation and in order to connect to the Grafana UI, its the service should be exposed on a port of a host VM as
```
kubectl --namespace monitoring port-forward svc/grafana HOSST_PORT:SVC_PORT  --address IP_VM 
```

