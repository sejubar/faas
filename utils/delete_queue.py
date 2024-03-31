from kombu import Connection

with Connection('amqp://admin:admin!@localhost:5672/') as connection:
    q = Queue("test-request-topic", channel=ch, no_declare=True)
    q.delete()

