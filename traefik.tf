resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  namespace  = "default"
  chart      = "traefik"
  version    = "9.8.1"

  depends_on = [module.eks.cluster_id]

  values = [
    yamlencode(
      {
        additionalArguments = [
          "--log.level=DEBUG",
          # Trust requests coming from local subnets, which are also used by NLB.
          # Keep in mind that app running inside our VPC could still fake requests!
          "--entrypoints.web.proxyprotocol=true",
          "--entryPoints.web.proxyprotocol.trustedIPs=10.0.0.0/16",

          # Close keep-alive connections after 60 seconds.
          #   - Make sure services have higher limit set (since we don't want e.g. Apache to close connection before Traefik does!)
          "--serverstransport.forwardingtimeouts.idleconntimeout=60",
          "--entrypoints.web.transport.respondingtimeouts.idletimeout=60",
          "--entrypoints.websecure.transport.respondingtimeouts.idletimeout=60",
        ]

        ports = {
          web = {
            port        = "8080"
            exposed     = "true"
            exposedPort = "80"
            protocol    = "TCP"
          }
        }
      }
    )
  ]
}
