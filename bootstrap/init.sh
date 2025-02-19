#!/bin/bash
set -eux

SCRIPT_DIR=$(cd $(dirname $0); pwd)


# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# bootstrap argocd app.
kubectl apply -f ${SCRIPT_DIR}/argocd-install.yaml

kubectl wait --for=condition=available --timeout=60s --all deployments

# apply argo-cd projects.
kubectl apply -f ${SCRIPT_DIR}/manifests/project.yaml
kubectl apply -f ${SCRIPT_DIR}/manifests/application.yaml