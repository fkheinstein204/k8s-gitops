
## Vault Install

```bash
```

```bash

$ kubectl get all -n vault -o wide

$ kubectl -n vault exec -it vault-0 -- vault operator init -status
Vault is not initialized
command terminated with exit code 2

$ kubectl -n vault exec -it vault-0 -- vault operator init



$ kubectl -n vault exec -it vault-0 -- vault operator unseal
$ kubectl -n vault exec -it vault-0 -- vault operator unseal
$ kubectl -n vault exec -it vault-0 -- vault operator unseal
$ kubectl -n vault exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
$ kubectl -n vault exec -it vault-1 -- vault operator unseal
$ kubectl -n vault exec -it vault-1 -- vault operator unseal
$ kubectl -n vault exec -it vault-1 -- vault operator unseal
$ kubectl -n vault exec -ti vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
$ kubectl -n vault exec -it vault-2 -- vault operator unseal
$ kubectl -n vault exec -it vault-2 -- vault operator unseal
$ kubectl -n vault exec -it vault-2 -- vault operator unseal



kubectl -n vault exec -it vault-0 -- vault login


# Enter vault pod
$ kubectl exec -ti vault-0 -- sh
# Login with root token
$ vault login

vault policy write external-secrets-policy -<<EOF
 path "*"
 {  capabilities = ["read"]
 }
EOF

vault auth enable kubernetes




# Populate wome variables regarding k8s configuration
$ k8s_host="$(kubectl exec vault-0 -n vault -- printenv | grep KUBERNETES_PORT_443_TCP_ADDR | cut -f 2- -d "=" | tr -d " ")"
$ k8s_port="443"
$ k8s_cacert="$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)"
$ tr_account_token="$(kubectl get secret -n vault vault-auth -o jsonpath='{ .data.token }' | base64 --decode)"

# Create the configuration into vault for Kubernetes authentication method
$ kubectl exec vault-0 -n vault -- \
vault write auth/kubernetes/config \
token_reviewer_jwt="${tr_account_token}" \
kubernetes_host="https://${k8s_host}:${k8s_port}" \
kubernetes_ca_cert="${k8s_cacert}" \
disable_issuer_verification=true


```