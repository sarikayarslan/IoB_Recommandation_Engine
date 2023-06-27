from kafka import KafkaProducer
import json
import pandas as pd
import numpy as np
import csv

def ads_sender(segment, ads):

   producer = KafkaProducer(
   bootstrap_servers='127.0.0.1:9092',
   value_serializer=lambda v: json.dumps(v).encode('utf-8')
   )
   ansequents = ads['antecedents']
   consequents = ads['consequents']
   producer.send(
   'Campaigns',
   value=
   {
      "segment": str(segment),
      "ansequents": ansequents.values.tolist(),
      "consequents": consequents.values.tolist()
      }
   )
 
   producer.flush()

stock_dict = {}

with open('data\products.csv', 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        stock_code = row['StockCode']
        description = row['Description']
        stock_dict[stock_code] = description
print(stock_dict)


dataset = pd.read_csv('data\sepet_analizi_result.csv',sep=',')
print(dataset.head(5))
print(dataset['antecedents'])

description_cons = pd.Series()
description_ans = pd.Series()

for value in dataset['antecedents']:
    stock_code = str(value)
    description = stock_dict.get(stock_code, "N/A")
    description_ans = description_ans.append(pd.Series(description))

for value in dataset['consequents']:
    stock_code = str(value)
    description = stock_dict.get(stock_code, "N/A")
    description_cons = description_cons.append(pd.Series(description))

print(description_cons)
print(description_ans)
ads2 = pd.DataFrame({"antecedents": description_ans, "consequents": description_cons})
ads2 = ads2.reset_index(drop=True)
print(ads2)
ads = dataset[['antecedents','consequents']]

print(ads)

ads_sender('Champions', ads2)


