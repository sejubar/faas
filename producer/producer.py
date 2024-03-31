"""

Example that sends a single message and exits using the simple interface.

You can use `simple_receive.py` (or `complete_receive.py`) to receive the
message sent.

"""
import random
from faker import Faker
import uuid
from kombu import Connection
fake = Faker()
def send_many(n):

    #: Create connection
    #: If hostname, userid, password and virtual_host is not specified
    #: the values below are the default, but listed here so it can
    #: be easily changed.
    # with Connection('amqp://admin:admin!@localhost:5672/') as connection:
    with Connection('amqp://admin:admin!@rabbitmq.rabbitmq-system.svc.cluster.local/') as connection:

        #: SimpleQueue mimics the interface of the Python Queue module.
        #: First argument can either be a queue name or a kombu.Queue object.
        #: If a name, then the queue will be declared with the name as the
        #: queue name, exchange name and routing key.
        with connection.SimpleQueue('request-topic') as queue:
        # with connection.SimpleQueue('test-topic') as queue:

            def send_message(i):
                queue.put(i)
            # List of items
            items = ['apple', 'banana', 'cherry', 'date', 'elderberry']
            status = ['CLOSED', 'OPEN', 'CANCELLED', 'COMPLETED']

            # Select a random item
            

            for i in range(50):
                    str_msg_id =  str(uuid.uuid4())
                    selected_item = random.choice(items)
                    selected_status= random.choice(status)
                    name = fake.name()
                    str_message_post = {"order_id":str_msg_id, "name": name, "status": selected_status, "item": selected_item}
                    send_message(str_message_post)   
                    print(f"sent: {str_message_post}")
                    str_msg_id = None 

def main():
    send_many(10)
    return {"status": 200}

# main()