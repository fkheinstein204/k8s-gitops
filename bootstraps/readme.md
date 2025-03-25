# Create a GitHub personal access token and export it as an env var
export GITHUB_TOKEN='<your-token>'

kubectl config use-context admin-prod@k8s-gitops

flux bootstrap github \
  --token-auth \
  --owner=fkheinstein204 \
  --repository=k8s-gitops \
  --branch=main \
  --path=./clusters/production \
  --personal=true \
  --private=false


kubectl config use-context admin-dev@k8s-gitops

flux bootstrap github \
  --token-auth \
  --owner=fkheinstein204 \
  --repository=k8s-gitops \
  --branch=main \
  --path=./clusters/development \
  --personal=true \
  --private=false 


