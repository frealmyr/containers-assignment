# Monitoring Summary

For this demo i opted for Grafana Cloud

  - Fully managed solution, with a ton of defaults. For all my metrics and log needs.
  - Agent is installed using Helm chart and Grafana wizard https://fmlab.grafana.net/a/grafana-k8s-app/configuration/cluster-config

Not much more to say here, grants me historical logs and metrics when I need them. For live logs i prefer using `stern` or argo-cd UI when working with gitops.
