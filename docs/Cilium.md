# Cilium Summary

Used this demo as a oppertunity to check out Azure AKS managed Cilium

  - Why?
    - L3 Network Policies is sweet
    - I wanted an excuse to test out managed Cilium in AKS, so now is the time!
  - Hubble is not yet available in managed, so we need to go CLI.

## Cilium Network Policies

Usually goes down like this:

  - Create a policy using the helper tool https://editor.networkpolicy.io/
  - Deploy said policy
  - Something does not answer anymore
  - Start debugging policy

### Monitoring without hubble requires some kubectl-wizardy

Case: the frontend can't talk with the backend

```bash
k exec testapiserver-d889b55f9-r7tvk -- curl -sI http://testapibackendsvc.assignment.svc.cluster.local:10000

command terminated with exit code 6
```

First, figure out the `cilium endpoint` of the application you want to check

```bash
kubectl -n assignment get cep
```

```bash
NAME                            ENDPOINT ID   IDENTITY ID   INGRESS ENFORCEMENT   EGRESS ENFORCEMENT   VISIBILITY POLICY   ENDPOINT STATE   IPV4          IPV6
testapi-5978dffc4d-sddsc        649           44380         <status disabled>     <status disabled>    <status disabled>   ready            10.244.0.32   
testapi-5978dffc4d-xw2ks        1144          44380         <status disabled>     <status disabled>    <status disabled>   ready            10.244.0.47   
testapiserver-d889b55f9-r7tvk   2302          576           <status disabled>     <status disabled>    <status disabled>   ready            10.244.0.40   
testapiserver-d889b55f9-xwqxr   344           576           <status disabled>     <status disabled>    <status disabled>   ready            10.244.0.28   
```

In this case, I want to monitor testpaiserver, so the endpoints are 334 and 2302

We can now tail Cilium for packet drops while sending requests:

```bash
kubectl -n kube-system exec -ti cilium-khb8n -- cilium monitor --from 344 --from 2302 --type drop
```

```bash
Defaulted container "cilium-agent" out of: cilium-agent, install-cni-binaries (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), systemd-networkd-overrides (init), block-wireserver (init)
Press Ctrl-C to quit
level=info msg="Initializing dissection cache..." subsys=monitor
xx drop (Policy denied) flow 0x186220a2 to endpoint 0, file bpf_lxc.c line 1182, , identity 576->519: 10.244.0.40:52908 -> 10.244.0.27:53 udp
xx drop (Policy denied) flow 0x186220a2 to endpoint 0, file bpf_lxc.c line 1182, , identity 576->519: 10.244.0.40:52908 -> 10.244.0.27:53 udp
xx drop (Policy denied) flow 0x9c9560fd to endpoint 0, file bpf_lxc.c line 1182, , identity 576->519: 10.244.0.40:37096 -> 10.244.0.14:53 udp
xx drop (Policy denied) flow 0x9c9560fd to endpoint 0, file bpf_lxc.c line 1182, , identity 576->519: 10.244.0.40:37096 -> 10.244.0.14:53 udp
xx drop (Policy denied) flow 0xfccbd49b to endpoint 0, file bpf_lxc.c line 1182, , identity 576->519: 10.244.0.40:48124 -> 10.244.0.14:53 udp
```

Aha! We can't reach the `kube-dns` pod. Ticking off kube-dns in the visual editor, and copy this into our policy

```yaml
      - toEndpoints:
          - matchLabels:
              io.kubernetes.pod.namespace: kube-system
              k8s-app: kube-dns
        toPorts:
          - ports:
              - port: "53"
                protocol: UDP
```

Deploy. Aaand, we have contact!

```bash
k exec testapiserver-d889b55f9-r7tvk -- curl -sI http://testapibackendsvc.assignment.svc.cluster.local:10000
HTTP/1.1 200 OK
Date: Tue, 06 Feb 2024 19:28:37 GMT
Content-Length: 29
Content-Type: text/plain; charset=utf-8
```