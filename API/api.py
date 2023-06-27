from flask import Flask
from kafka import KafkaConsumer
from flask_cors import CORS


app = Flask(__name__)
CORS(app)

@app.route('/')
def get_kafka_message():
    # Kafka sunucusuna bağlanan tüketiciyi oluştur
    consumer = KafkaConsumer('Campaigns', bootstrap_servers='127.0.0.1:9092',auto_offset_reset='latest')

    # Kafka'dan veri al
    for message in consumer:
        print(message)
        kafka_message = message.value.decode('utf-8')
        # Veriyi Flask üzerinden gönder
        response = app.response_class(
            response=kafka_message,
            status=200,
            mimetype='application/json'
        )
        return response

    # Veri yoksa "data yok" döndür
    return "data yok"

if __name__ == '__main__':
    app.run(host='192.168.3.???')