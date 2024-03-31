helm upgrade fission fission-charts/fission-all --set mqt_keda.enabled=true --namespace fission
kubectl port-forward --namespace rabbitmq-system svc/rabbitmq 15672:15672
kubectl port-forward --namespace rabbitmq-system svc/rabbitmq 5672:5672

https://fission.io/blog/building-a-serverless-url-shortener-with-mongodb-atlas-and-fission/

* A Python producer function (producer) that drops a message in a RabbitMQ queue named request-topic.

* Fission RabbitMQ trigger activates upon message arrival in request-topic and invokes another function (consumer) with message received from producer.

* The consumer function (consumer) gets body of message and returns a response.

* Fission RabbitMQ trigger takes the response of consumer function (consumer) and drops the message in a response queue named response-topic. If there is an error, the message is dropped in error queue named error-topic.
Sample App

## 
* publish orders to incoming queue with status OPEN, IN PROGRESS, CLOSED, CANCELLED.
* sort the orders based on status to different queues 
* if there is any error massage is published to error queue
* publish messages in cloud event formats
