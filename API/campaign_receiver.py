import json
from kafka import KafkaConsumer


def user_name_receiver():
    # Kafka sunucusu ve konu ayarları
    bootstrap_servers = '127.0.0.1:9092'
    topic = 'Campaigns'

    # Kafka consumer ayarları
    consumer = KafkaConsumer(topic,
                            bootstrap_servers=bootstrap_servers,
                            group_id='g1',
                            value_deserializer=lambda m: json.loads(m.decode('utf-8')))
    # Mesajları dinleme döngüsü
    for message in consumer:
        json_message = message.value
        print("Received message:")
        print(json.dumps(json_message, indent=2))
        return json_message
    consumer.close()
    

user_name_receiver()

