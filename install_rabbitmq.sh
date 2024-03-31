helm repo add bitnami https://charts.bitnami.com/bitnami &&
helm install -n rabbitmq-system --create-namespace rabbitmq bitnami/rabbitmq \
  --set clustering.enabled=false \
  --set auth.username=admin --set auth.password=admin!\
  --set persistence.size=5Gi \
  --wait
  