
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

```