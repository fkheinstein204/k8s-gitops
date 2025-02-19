#!/bin/bash
set -eux

SCRIPT_DIR=$(cd $(dirname $0); pwd)


# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# bootstrap argocd app.

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
#helm install argocd -n argocd -f ${SCRIPT_DIR}/argocd/dev-values.yaml argo/argo-cd --create-namespace --wait
helm upgrade argocd -n argocd -f ${SCRIPT_DIR}/argocd/dev-values.yaml argo/argo-cd --create-namespace --wait

# apply argo-cd projects.
kubectl apply -f ${SCRIPT_DIR}/manifests/namespaces.yaml
kubectl apply -f ${SCRIPT_DIR}/manifests/project.yaml
kubectl apply -f ${SCRIPT_DIR}/manifests/application.yaml

# argocd app
#kubectl apply -f ${SCRIPT_DIR}/argocd-install.yaml
