from kombu import Connection
import time
def wait_many(timeout=60):

    #: Create connection
    #: If hostname, userid, password and virtual_host is not specified
    #: the values below are the default, but listed here so it can
    #: be easily changed. rabbitmq.rabbitmq-system.svc.cluster.local
    # with Connection('amqp://admin:admin!@localhost:5672/') as connection:
    with Connection('amqp://admin:admin!@rabbitmq.rabbitmq-system.svc.cluster.local') as connection:
        #: SimpleQueue mimics the interface of the Python Queue module.
        #: First argument can either be a queue name or a kombu.Queue object.
        #: If a name, then the queue will be declared with the name as the
        #: queue name, exchange name and routing key.
        message_list = []
        # with connection.SimpleQueue('test-topic') as queue:
        stauses = ['COMPLETED', 'OPEN', 'CANCELLED']
        with connection.SimpleQueue('request-topic') as queue:
            while True:
                try:
                    message = queue.get(block=True, timeout=timeout)
                except queue.Empty:
                    break
                else:
                    message.ack()
                    print(f"recieved: {message.payload}")
                    message_list.append(message.payload)
        for msg in  message_list:
            if msg["status"] in stauses:
                with connection.SimpleQueue(msg["status"].lower()) as queue:
                    queue.put(msg)     
            else:
                with connection.SimpleQueue("unknown") as queue:   
                    queue.put(msg)                            
def main():
    wait_many()
    return {"status": 204}
       
# main()
