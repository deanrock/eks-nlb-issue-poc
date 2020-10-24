# EKS NLB Traefik issue PoC

## Setup
```shell
$ terraform init
$ terraform plan -out ./plan
$ terraform apply ./plan
```

## Update kubeconfig
```shell
$ aws eks --region $(terraform output region) update-kubeconfig --name $(terraform output cluster_name)
```
