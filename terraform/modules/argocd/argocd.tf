resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  version = "5.53.14"

  namespace        = "argocd"
  create_namespace = true

  values = [<<EOF
    applicationSet:
      enabled: true

    metrics:
      enabled: true
      serviceMonitor:
        enabled: false

    controller:
      replicas: 1
      metrics:
        enabled: true
        serviceMonitor:
          enabled: false
      containerSecurityContext:
        capabilities:
          drop:
            - all
        readOnlyRootFilesystem: true
        runAsNonRoot: true

    dex:
      enabled: false

    repoServer:
      autoscaling:
        enabled: true
        minReplicas: 2

    server:
      autoscaling:
        enabled: true
        minReplicas: 2
      extraArgs:
        - --insecure # Using traefik for TLS termination instead of argocd

    configs:
      cm:
        create: false # Create a custom one in extraObjects, because I enjoy working syncWaves in apps-of-apps

    extraObjects:
      - apiVersion: v1
        kind: ConfigMap
        metadata:
          name: argocd-cm
          labels:
            app.kubernetes.io/component: server
            app.kubernetes.io/instance: argocd
            app.kubernetes.io/managed-by: Helm
            app.kubernetes.io/part-of: argocd
        data:
          admin.enabled: "true"
          exec.enabled: "true"
          url: https://argocd.mgmt.fmlab.no
          resource.customizations: |
            argoproj.io/Application:
              health.lua: |
                hs = {}
                hs.status = "Progressing"
                hs.message = ""
                if obj.status ~= nil then
                  if obj.status.health ~= nil then
                    hs.status = obj.status.health.status
                    if obj.status.health.message ~= nil then
                      hs.message = obj.status.health.message
                    end
                  end
                end
                return hs
  EOF
  ]
}

resource "helm_release" "argocd_apps_demo" {
  name       = "argocd-apps-demo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"

  version = "1.6.1"

  values = [<<EOF
    applications:
      - name: demo
        namespace: argocd
        finalizers:
          - resources-finalizer.argocd.argoproj.io
        project: default
        source:
          repoURL: https://github.com/frealmyr/containers-assignment.git
          targetRevision: main
          path: gitops
        destination:
          name: in-cluster
        syncPolicy:
          automated:
            prune: true
            selfHeal: false
  EOF
  ]

  depends_on = [helm_release.argocd]
}
