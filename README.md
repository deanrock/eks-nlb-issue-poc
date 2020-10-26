# EKS NLB Traefik issue PoC

## Setup
```shell
terraform init
terraform plan -out ./plan
terraform apply ./plan
```

## Update kubeconfig
```shell
aws eks --region $(terraform output region) update-kubeconfig --name $(terraform output cluster_name)
```

## `curl` test
```shell
# start ubuntu pod and attach
kubectl run -i --tty ubuntu --image=ubuntu -- bash

# run inside
apt update && apt install -y curl
URL="http://$(terraform output nlb_hostname)/" i=1; while true; do i=$((i+1)); echo $i; time curl $URL 1> /dev/null 2>&1; done;
```

### simple PHP client
```shell
kubectl run -i --rm --tty client --env="URL=http://$(terraform output nlb_hostname)/" --image=quay.io/deanrock/simple-http-client@sha256:3f1ff8c2c0076624d5cedf949c08106272e7c39250abbfce3786b8a895a27795
```

### install `simple PHP client` via Deployment
```shell
helm upgrade --install client charts/client --set url="http://$(terraform output nlb_hostname)/"
```

### install `simple PHP client` via Deployment and target ELB
```shell
helm upgrade --install client charts/client --set url="http://$(terraform output elb_hostname)/"
```

### install `tcpdump` via DaemonSet
```shell
helm upgrade --install tcpdump charts/tcpdump
```
