terraform apply:

```bash
cd terraform/
terraform init
terraform apply
```

```bash
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```

---

fetch aks kubeconfig

```
az aks get-credentials --resource-group aks-demo --name aks-demo --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

---

#### Check cluster status

  - Check that nodes are healthy,ready
  - Check that zones are unique
  - Check status of pods

```bash
kubectl get nodes -o wide
kubectl describe nodes | grep -e "Name:" -e "topology.kubernetes.io/zone"
kubectl get pods -A
```

```bash
kgno -A
NAME                              STATUS   ROLES   AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-default-21926331-vmss000000   Ready    agent   46m   v1.27.7   10.122.0.4    <none>        Ubuntu 22.04.3 LTS   5.15.0-1053-azure   containerd://1.7.5-1
aks-default-21926331-vmss000001   Ready    agent   82s   v1.27.7   10.122.0.5    <none>        Ubuntu 22.04.3 LTS   5.15.0-1053-azure   containerd://1.7.5-1

kdno | grep -e "Name:" -e "topology.kubernetes.io/zone"
Name:               aks-default-21926331-vmss000000
                    topology.kubernetes.io/zone=eastus-2
Name:               aks-default-21926331-vmss000001
                    topology.kubernetes.io/zone=eastus-1

kgp -Ao wide
NAMESPACE     NAME                                  READY   STATUS    RESTARTS   AGE     IP            NODE                              NOMINATED NODE   READINESS GATES
kube-system   azure-cns-8mh4m                       1/1     Running   0          2m10s   10.122.0.5    aks-default-21926331-vmss000001   <none>           <none>
kube-system   azure-cns-h8mdb                       1/1     Running   0          47m     10.122.0.4    aks-default-21926331-vmss000000   <none>           <none>
kube-system   cilium-l4wfk                          1/1     Running   0          2m10s   10.122.0.5    aks-default-21926331-vmss000001   <none>           <none>
kube-system   cilium-mm6vk                          1/1     Running   0          45m     10.122.0.4    aks-default-21926331-vmss000000   <none>           <none>
kube-system   cilium-operator-fb4c58f8d-zdmbs       1/1     Running   0          45m     10.122.0.4    aks-default-21926331-vmss000000   <none>           <none>
kube-system   cloud-node-manager-hg8d2              1/1     Running   0          47m     10.122.0.4    aks-default-21926331-vmss000000   <none>           <none>
kube-system   cloud-node-manager-lnbjc              1/1     Running   0          2m10s   10.122.0.5    aks-default-21926331-vmss000001   <none>           <none>
kube-system   coredns-789789675-k24m6               1/1     Running   0          45m     10.244.0.13   aks-default-21926331-vmss000000   <none>           <none>
kube-system   coredns-789789675-lps6p               1/1     Running   0          47m     10.244.0.19   aks-default-21926331-vmss000000   <none>           <none>
kube-system   coredns-autoscaler-649b947bbd-q2s9n   1/1     Running   0          47m     10.244.0.10   aks-default-21926331-vmss000000   <none>           <none>
kube-system   csi-azuredisk-node-7fkbh              3/3     Running   0          47m     10.122.0.4    aks-default-21926331-vmss000000   <none>           <none>
kube-system   csi-azuredisk-node-kw5tq              3/3     Running   0          2m10s   10.122.0.5    aks-default-21926331-vmss000001   <none>           <none>
kube-system   csi-azurefile-node-h57sj              3/3     Running   0          47m     10.122.0.4    aks-default-21926331-vmss000000   <none>           <none>
kube-system   csi-azurefile-node-lzz6s              3/3     Running   0          2m10s   10.122.0.5    aks-default-21926331-vmss000001   <none>           <none>
kube-system   konnectivity-agent-867b5fb9bb-h6zww   1/1     Running   0          47m     10.244.0.6    aks-default-21926331-vmss000000   <none>           <none>
kube-system   konnectivity-agent-867b5fb9bb-xz97g   1/1     Running   0          45m     10.244.0.15   aks-default-21926331-vmss000000   <none>           <none>
kube-system   metrics-server-5955767688-8s2ld       1/2     Running   0          13s     10.244.0.26   aks-default-21926331-vmss000001   <none>           <none>
kube-system   metrics-server-5955767688-z2t62       1/2     Running   0          14s     10.244.0.31   aks-default-21926331-vmss000001   <none>           <none>
kube-system   metrics-server-5bd48455f4-tht5s       2/2     Running   0          45m     10.244.0.9    aks-default-21926331-vmss000000   <none>           <none>
```

### Cilium

#### Check cilium status

```
cilium status
```

```bash
cilium status

    /¯¯\
 /¯¯\__/¯¯\    Cilium:             OK
 \__/¯¯\__/    Operator:           OK
 /¯¯\__/¯¯\    Envoy DaemonSet:    disabled (using embedded mode)
 \__/¯¯\__/    Hubble Relay:       disabled
    \__/       ClusterMesh:        disabled

Deployment             cilium-operator    Desired: 1, Ready: 1/1, Available: 1/1
DaemonSet              cilium             Desired: 2, Ready: 2/2, Available: 2/2
Containers:            cilium             Running: 2
                       cilium-operator    Running: 1
Cluster Pods:          7/7 managed by Cilium
Helm chart version:    0.1.0-026c25c36944933c8e1b1e31bf749440b427d61b
Image versions         cilium             mcr.microsoft.com/oss/cilium/cilium:1.12.10-3: 2
                       cilium-operator    mcr.microsoft.com/oss/cilium/operator-generic:1.12.10: 1
```

#### Run connectivity test

```bash
cilium connectivity test
```

```bash

```