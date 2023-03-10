Here I faced a problem regarding the resource distributor for *CRI* and *kubelet* service.
For both of them it should be either *systemd* or *cgroups*.

In order to set *systemd* distributor in containerd CRI, these lines should be added to the file "/etc/containerd/config.toml":
````
[plugins."io.containerd.grpc.v1.cri"]
  systemd_cgroup = true
````

and restart both *containerd* and *kubelet* services.
It is explained in [desc = unknown service runtime.v1alpha2.RuntimeService](https://serverfault.com/questions/1074008/containerd-1-4-9-unimplemented-desc-unknown-service-runtime-v1alpha2-runtimese).

Besides, one has to make sure that the *kubelet* service also uses the *systemd* distributor by defining **KubeletConfiguration** in file "/var/lib/kubelet/config.yaml" as:
````
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
````

***HOWEVER, the default distributor for kubelet should be systemd which makes this step reduntant***