
  helm upgrade --install \
      cilium \
      cilium/cilium \
        --version 1.17.2 \
        --namespace kube-system \
        --set ipam.mode=kubernetes \
        --set kubeProxyReplacement=true \
        --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
        --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
        --set cgroup.autoMount.enabled=false \
        --set cgroup.hostRoot=/sys/fs/cgroup  \
        --set k8sServiceHost=10.128.1.80 \
        --set k8sServicePort=6443 \
        --set l2announcements.enabled=true



## Create a GitHub personal access token and export it as an env var

```bash

export GITHUB_TOKEN='<your-token>'

kubectl config use-context admin-prod@k8s-prod.lab

flux bootstrap github \
  --token-auth \
  --owner=fkheinstein204 \
  --repository=k8s-gitops \
  --branch=main \
  --path=./clusters/production \
  --cluster-domain=k8s-prod.lab  \
  --personal=true \
  --private=false


kubectl config use-context admin-dev@k8s-dev.lab

flux bootstrap github \
  --token-auth \
  --owner=fkheinstein204 \
  --repository=k8s-gitops \
  --branch=main \
  --path=./clusters/development \
  --cluster-domain=k8s-dev.lab  \
  --personal=true \
  --private=false 

```
