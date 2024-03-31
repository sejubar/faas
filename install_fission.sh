#!/bin/bash
source lib_utility

curl -sS https://webinstall.dev/k9s | bash
export FISSION_NAMESPACE="fission" &&
export FISSION_URL=http://$(minikube ip):31313
export FISSION_ROUTER=$(minikube ip):31314
kubectl create namespace $FISSION_NAMESPACE  &&
kubectl create -k "github.com/fission/fission/crds/v1?ref=v1.20.1" &&
helm repo add fission-charts https://fission.github.io/fission-charts/ &&
helm repo update  &&
helm install --version v1.20.1 --namespace $FISSION_NAMESPACE fission fission-charts/fission-all &&
curl -Lo fission https://github.com/fission/fission/releases/download/v1.20.1/fission-v1.20.1-linux-amd64 \
    && chmod +x fission && sudo mv fission /usr/local/bin/ 

echo "install keda"
helm repo add kedacore https://kedacore.github.io/charts &&
helm repo update &&
helm install keda kedacore/keda --namespace keda --create-namespace  &&
helm upgrade fission fission-charts/fission-all --set mqt_keda.enabled=true --namespace $FISSION_NAMESPACE &&
# kubectl apply -f secret.yaml --namespace $FISSION_NAMESPACE &&
kubectl apply -f secret.yaml --namespace default &&

fission version && 
fission check
