# Kubernetes Manifests for Jenkins Deployment

Refer [Setup Jenkins On Kubernetes](https://www.jenkins.io/doc/book/installing/kubernetes/) for step by step process to use these manifests.

If you don’t want the local storage persistent volume, you can replace the volume definition in the deployment with the host directory as shown below.
```
volumes:
- name: jenkins-data
  emptyDir: {}
```
Otherwise the name of the node that Jenkin's pod runs on should be set in the volume manifest for ***PV***:
```
nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - NODENAME
```