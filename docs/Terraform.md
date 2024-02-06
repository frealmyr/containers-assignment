# Terraform Summary

  - opted for terraform modules to seperate concerns
    - `./ad` contains IAM group creation
    - `./aks` contains anything Azure Kubernets Service related
    - `./argocd` contains ArgoCD helm chart installation and initial apps-of-apps argo-app.
    - `./kv` contains a basic key vault, and initial work for workload identity

## AD

This module contains a resource for granting access to AKS.

## AKS

This module creates a AKS cluster:

  - Uses zone `1, 2` in `US East` (cheapest) for dual-zone cluster
    - To be used with multiple pods for high availability
  - Uses managed Cilium
    - For that sweet L3 networkpolicy support
    - Managed does not yet support hubble, so insights are limited to CLI
  - Uses dedicated virtual network
    - Pre-req for managed cilium
    - seperate subnets for pods and nodes
  - Deploys ArgoCD using Helm Chart
    - Deployed in HA configuration
    - Dex disabled, so only admin password for MVP
    - Initial apps-of-apps argo-application is deployed using official argocd-apps helm chart.
      - Targets current git repository `./gitops` folder
      - auto-discovery on `Chart.yaml`
  - Started on Workload Identity and Vault integration
    - Dropped due to time constraints
    - Missing connection between workload identity and entra

