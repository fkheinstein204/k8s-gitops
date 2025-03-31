# HashiCorp Vault

HashiCorp Vault is a secrets management tool that helps to provide secure, automated access to sensitive data. Vault handles leasing, key revocation, key rolling, auditing, and provides secrets as a service through a unified API.

Latest version of [Vault](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install).

Vaults own [documentation](https://developer.hashicorp.com/vault/docs).

## Deploying Vault

1. Create and change directory to `infrastructure/base/vault`

2. Create `namespace.yaml`

```bash
kubectl create namespace vault \
  --dry-run=client \
  --output=yaml > namespace.yaml
```

3. Create `helmrepository.yaml`

```bash
flux create source helm hashicorp \
    --interval=1h \
    --url=https://helm.releases.hashicorp.com \
    --export > helmrepository.yaml
```

4. Create `helmrelease.yaml`

```bash
flux create helmrelease vault \
    --interval=1h \
    --release-name=vault \
    --namespace=vault \
    --target-namespace=vault \
    --source=HelmRepository/hashicorp.flux-system \
    --chart=vault \
    --chart-version=">=0.27.0-0" \
    --export > helmrelease.yaml
```

5. Create `kustomization.yaml`

```bash
kustomize create --autodetect
```

6. Commit your changes to Git

## Connecting to Vault

1. Port forward the Vault server

```bash
kubectl port-forward -n vault svc/vault 8200:8200
```

2. Set the `VAULT_ADDR` environment variable

```bash
export VAULT_ADDR=http://localhost:8200
```

3. Check the status of Vault

```bash
vault status
```

## Initialize Vault

1. Connect to Vault with [Connecting to Vault](#connecting-to-vault) section

2. Initialize Vault

```bash
vault operator init
```

Save the `root_token` and `unseal_keys` in a safe place.

3. Unseal Vault (run 3 times) with the keys from the previous command

```bash
vault operator unseal <UNSEAL_KEY>
```

## Enabling the Kubernetes Authentication Method

1. Exec into the Vault pod

```bash
kubectl exec -it vault-0 -n vault -- sh
```

2. Login to Vault

```bash
vault login <ROOT_TOKEN>
```

3. Enable the Kubernetes authentication method

```bash
vault auth enable kubernetes
```

4. Set Variables

```bash
export K8S_HOST=https://$KUBERNETES_PORT_443_TCP_ADDR:443 \
  SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
  K8S_CACERT_PATH=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

5. Configure the Kubernetes authentication method

```bash
vault write auth/kubernetes/config \
  kubernetes_host="$K8S_HOST" \
  token_reviewer_jwt=$SA_TOKEN \
  kubernetes_ca_cert=@$K8S_CACERT_PATH
```

6. Exit the Vault pod

```bash
exit
```

## Secrets Engines

You can find all the different secrets engines in HashiCorp's own [docs](https://developer.hashicorp.com/vault/docs/secrets). But here are some common examples.

## Vault "Key/Value" Secrets Engine

### Enabling the "Key/Value" Secrets Engine

1. Follow the steps in [Enabling the Kubernetes Authentication Method](#enabling-the-kubernetes-authentication-method) section

2. Connect to Vault with [Connecting to Vault](#connecting-to-vault) section

3. Login to Vault

```bash
vault login <ROOT_TOKEN>
```

4. Enable the secrets engine

With kv-v2 (recommended)

```bash
vault secrets enable kv-v2
```

With kv-v1

```bash
vault secrets enable kv
```

### Creating a Secret

1. Create a Vault Secret

With kv-v2 (recommended)

```bash
vault kv put secret/data/api/cred key="<KEY>" secret="<SECRET>"
```

With kv-v1

```bash
vault kv put secret/api/cred key="<KEY>" secret="<SECRET>"
```

## Vault "Database" Secrets Engine

### Enabling the "Database" Secrets Engine

Once you have a database up and running, and a vault user with the correct permissions, you can enable the database secrets engine.

1. Follow the steps in [Enabling the Kubernetes Authentication Method](#enabling-the-kubernetes-authentication-method) section

2. Connect to Vault with [Connecting to Vault](#connecting-to-vault) section

3. Login to Vault

```bash
vault login <ROOT_TOKEN>
```

4. Enable the secrets engine

```bash
vault secrets enable database
```

5. Configure the database secrets engine

```bash
vault write database/config/my-postgres-server-name \
  plugin_name="postgresql-database-plugin" \
  allowed_roles="my-postgres-role" \
  connection_url="postgresql://{{username}}:{{password}}@postgres.postgres.svc.cluster.local:5432/postgres" \
  username="vault" \
  password="vaultpassword" \
  password_authentication="scram-sha-256"
```

6. Create a Vault Role for your namespace

```bash
vault write database/roles/my-postgres-role \
  db_name="my-postgres-server-name" \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
      GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="1h" \
  max_ttl="24h"
```

## Vault "RabbitMQ" Secrets Engine

### Enabling the "RabbitMQ" Secrets Engine

Vault RabbitMQ [docs](https://developer.hashicorp.com/vault/docs/secrets/rabbitmq)

Once you have a RabbitMQ up and running, and a vault user with the correct permissions, you can enable the RabbitMQ secrets engine.

1. Enable the secrets engine

```bash
vault secrets enable rabbitmq
```

2. Configure the RabbitMQ secrets engine

```bash
vault write rabbitmq/config/connection \
  connection_uri="http://rabbitmq-management.rabbitmq.svc.cluster.local:15672" \
  username="vault" \
  password="password"
```

3. Create a Vault Role for your namespace

```bash
vault write rabbitmq/roles/my-role \
  vhosts='{"/":{"write": ".*", "read": ".*"}}'
```

### Authenticating your application with Vault

1. Create a Kubernetes service account

```bash
kubectl create serviceaccount vault-auth -n app-namespace
```

2. Create a Vault Role

```bash
vault write auth/kubernetes/role/app-api-read \
  bound_service_account_names=vault-auth \
  bound_service_account_namespaces=app-namespace \
  policies=app-api-read \
  ttl=1h
```

3. Create a policy

```bash
vault policy write app-api-read - <<EOF
path "kv/data/app/*" {
  capabilities = ["read"]
}
EOF
```
