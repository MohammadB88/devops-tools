# Kubernetes Manifests for Jenkins Deployment

Refer to [Setup Jenkins On Kubernetes](https://www.jenkins.io/doc/book/installing/kubernetes/) for step by step process to use these manifests.

If you don’t want the local storage persistent volume, you can replace the volume definition in the deployment with the host directory as shown below.
```
volumes:
- name: jenkins-data
  emptyDir: {}
```

Otherwise volume manifest shloud also be deployed, in which the name of the node that Jenkin's pod runs on has to be set for ***PV***:
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

***However, enabling docker inside Jenkins to build images is a tedious tasks***

Docker *client* and *daemon* are required to run docker whitin Jenkis based on [best practice using docker inside Jenkins](https://stackoverflow.com/questions/50237433/best-practice-using-docker-inside-jenkins).

Client component can be installed when the custom Jenkins image is prepared ("docker-in-docker approach"), as discussed vastly in below links: 
- [How to build docker images inside a Jenkins container](https://medium.com/@manav503/how-to-build-docker-images-inside-a-jenkins-container-d59944102f30)
- [Jenkins in Docker: Running Docker in a Jenkins Container](https://hackmamba.io/blog/2022/04/running-docker-in-a-jenkins-container/)

Here is the Dockerfile to create the custom Jenkins image:
```
from jenkinsci/jenkins:lts
 
USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common 

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update  -qq \
    && apt-get -y install docker-ce

RUN usermod -aG docker jenkins

RUN echo "jenkins ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jenkins
```
  
Another solution is to use the docker client from the host machine which is not that stable and discussed in details in:
- [Using docker in a dockerized Jenkins container](https://forums.docker.com/t/using-docker-in-a-dockerized-jenkins-container/322)

Basically, using volume mount feature, docker client on the host will be linked inside the jenkins kubernetes manifest:
```
  volumeMounts:
    - name: docker-client
      mountPath: /usr/bin/docker
  volumes:
    - name: docker-client
      hostPath:
        path: /usr/bin/docker
        type: File
```

or directly in docker run:
````
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -p 8080:8080 jenkins-docker
````


```
docker run -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -v /smb/jenkins_home:/var/jenkins_home jenkins-docker
```

