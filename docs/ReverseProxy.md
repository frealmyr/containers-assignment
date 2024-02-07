# Reverse Proxy Summary

For this demo I opted for Traefik

  - It's quick to get up and running
  - I have experience with maintaining Traefik
  - I also had plans to route argocd-ui and traefik dashboard, however scrapped due to time constraints
  - I only need one LoadBalancer for all traffic, and IPs are expensive nowadays

Simplified network flow diagram inside kubernetes

```mermaid
  graph TD

  subgraph "namespace: traefik"
  www -- "HTTP GET https://172.171.137.44/view/customer" --> lb("LoadBalancer: traefik")
  lb --> tpod("Pod: traefik-xxx")
  end

  subgraph "namespace: assignment"
  tpod -- "Reverse proxy matched IngressRoute prefix\n forward request to" --> svc("Service: testapiserversvc")
  svc -- "round robin" --> pod1("Pod: testapiserver-xxx-xx1" )
  svc -- "round robin" --> pod2("Pod: testapiserver-xxx-xx2" )
  end
```
