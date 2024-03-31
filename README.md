


* A Python producer function (producer)  publishes orders with statuses OPEN, IN PROGRESS, CLOSED, CANCELLED into a RabbitMQ queue named request-topic.

* Fission RabbitMQ trigger activates upon message arrival to request-topic and invokes another function (consumer) with message received from producer.  If there is an error, the message is dropped in error queue named error-topic.

* The consumer function (consumer) gets body of message returns a response to response-topic and sort the orders based on status to different queues.


