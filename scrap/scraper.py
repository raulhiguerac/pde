from datetime import datetime
from unidecode import unidecode
from google.cloud import storage
# from google.oauth2 import service_account
# import json

import math
import time
import requests
import pandas as pd

class Scraper:
  def __init__(self):
    self.headers = {'authority': 'kong.fincaraiz.com.co','accept': '*/*','accept-language': 'es-CO,es;q=0.9',
    'content-type': 'application/json','origin': 'https://www.fincaraiz.com.co','referer': 'https://www.fincaraiz.com.co/',
    'sec-ch-ua': '"Chromium";v="122", "Not(A:Brand";v="24", "Google Chrome";v="122"','sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"','sec-fetch-dest': 'empty','sec-fetch-mode': 'cors','sec-fetch-site': 'same-site',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36'}

  def make_request(self, city: str, min_price: int, max_price: int):
    cities = {
      "bogota":{"posicion_1":"city-colombia-11-001","posicion_2":"colombia-cundinamarca-3630001-bogotá"},
      "medellin":{"posicion_1":"city-colombia-05-001","posicion_2":"colombia-antioquia-5500006-medellín"},
      "barranquilla":{"posicion_1":"city-colombia-08-001","posicion_2":"colombia-atlántico-5700003-barranquilla"},
      "cali":{"posicion_1":"city-colombia-76-001","posicion_2":"colombia-valle-del-cauca-8200006-cali"},
      "cartagena":{"posicion_1":"city-colombia-13-001","posicion_2":"colombia-bolívar-5800003-cartagena"},
      "manizales":{"posicion_1":"city-colombia-17-001","posicion_2":"colombia-caldas-6000006-manizales"},
      "pereira":{"posicion_1":"city-colombia-66-001","posicion_2":"colombia-risaralda-7800004-pereira"},
      "envigado":{"posicion_1":"city-colombia-05-266","posicion_2":"colombia-antioquia-5500001-envigado"},
      "bucaramanga":{"posicion_1":"city-colombia-68-001","posicion_2":"colombia-santander-7500007-bucaramanga"},
      "chia":{"posicion_1":"city-colombia-25-175","posicion_2":"colombia-cundinamarca-6700003-chía"},
      "armenia":{"posicion_1":"city-colombia-63-001","posicion_2":"colombia-quindío-7700006-armenia"},
      "bello":{"posicion_1":"city-colombia-05-088","posicion_2":"colombia-antioquia-5500005-bello"},
      "santa_marta":{"posicion_1":"city-colombia-47-001","posicion_2":"colombia-magdalena-7200003-santa-marta"},
      "cajica":{"posicion_1":"city-colombia-25-126","posicion_2":"colombia-cundinamarca-6700009-cajicá"},
      "itagui":{"posicion_1":"city-colombia-05-360","posicion_2":"colombia-antioquia-5500002-itaguí"},
      "soacha":{"posicion_1":"city-colombia-25-754","posicion_2":"colombia-cundinamarca-6700004-soacha"},
      "floridablanca":{"posicion_1":"city-colombia-68-276","posicion_2":"colombia-santander-7500001-floridablanca"},
      "mosquera":{"posicion_1":"city-colombia-25-473","posicion_2":"colombia-cundinamarca-6700002-mosquera"},
      "madrid":{"posicion_1":"city-colombia-25-430","posicion_2":"colombia-cundinamarca-6700012-madrid"},
    }
    json_data = {'filter': {'offer': {'slug': ['sell',],},'is_new': False,
                            "locations":{"cities":{"slug":[cities[city]["posicion_1"],cities[city]["posicion_2"]]}},
                            "price":{"gte":min_price,"lte":max_price},},
        'fields': {
            'exclude': [],
            'facets': [],
            'include': [
                'area','baths.id','baths.name','baths.slug','client.client_type','client.company_name',
                'client.first_name','client.fr_client_id','client.last_name','client.logo.full_size','garages.name',
                'is_new','locations.cities.fr_place_id','locations.cities.name','locations.cities.slug',
                'locations.countries.fr_place_id','locations.countries.name','locations.countries.slug',
                'locations.groups.name','locations.groups.slug','locations.groups.subgroups.name',
                'locations.groups.subgroups.slug','locations.neighbourhoods.fr_place_id',
                'locations.neighbourhoods.name','locations.neighbourhoods.slug','locations.states.fr_place_id',
                'locations.states.name','locations.states.slug','locations.location_point',
                'locations.location_main.id','locations.location_main.fr_place_id',
                'locations.location_main.place_code','locations.location_main.name','locations.location_main.slug',
                'locations.location_main.location_type','max_area','max_price',
                'min_area','min_price','offer.name','price','products.configuration.tag_id',
                'products.configuration.tag_name','products.label','products.name','products.slug','property_id',
                'property_type.name','fr_property_id','fr_parent_property_id','rooms.id','rooms.name','rooms.slug',
                'stratum.name','floor.name','administration.price','dates.created','dates.published','dates.updated',
                'description','address','age.name','title',
            ],
            'limit': 10000,
            'offset': 0,
            'ordering': [],
            'platform': 40,
            'with_algorithm': True,
        },
      }
    response = requests.post('https://kong.fincaraiz.com.co/api/v1/listings/search', headers=self.headers, json=json_data)
    return response.json()

  def save_data_gcs(self, bucket_name: str, source_file: str, destination_file: str):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_file)
    blob.upload_from_filename(source_file)

    return True
  
  def struct_data(self, bucket_name: str, city: str, min_price: int, max_price: int):
    data = self.make_request(city,min_price,max_price)
    res = []
    for p in data['hits']['hits']:
      try:
        property_data = {
            "id":p['_id'],
            "area_m2":int(float(p['_source']['listing']['area'])),
            "cuartos":p['_source']['listing']['rooms']['id'],
            "estrato":p['_source']['listing']['stratum']['name'].split(' ')[1],
            "tipo":p['_source']['listing']['offer'][0]['name'].lower(),
            "parqueaderos":p['_source']['listing']['garages']['name'],
            "banios":p['_source']['listing']['baths']['name'],
            "piso":p['_source']['listing']['floor']['name'],
            "precio":int(float(p['_source']['listing']['price'])),
            "precio_m2":round(int(float((p['_source']['listing']['price'])))/int(float((p['_source']['listing']['area']))),2),
            "precio_admin":p['_source']['listing']['administration']['price'],
            "vendedor":p['_source']['listing']['client']['company_name'],
            "tipo_vendedor":p['_source']['listing']['client']['client_type'],
            "tipo_propiedad":p['_source']['listing']['property_type'][0]['name'].lower(),
            "barrio":unidecode(p['_source']['listing']['locations']['neighbourhoods'][0]['name'].replace(' ', '-').lower()),
            "ciudad":unidecode(p['_source']['listing']['locations']['cities'][0]['name'].lower()),
            "lat":p['_source']['listing']['locations']['location_point'].split(' ')[2].replace(')',''),
            "lon":p['_source']['listing']['locations']['location_point'].split(' ')[1].replace('(',''),
            "direccion":p['_source']['listing']['address'].split('"')[3].split(',')[0],
            "id_propiedad":p['_source']['listing']['fr_property_id'],
            "creado":datetime.fromisoformat(p['_source']['listing']['dates']['created']).strftime("%Y-%m-%d %H:%M:%S"),
            "publicado":datetime.fromisoformat(p['_source']['listing']['dates']['published']).strftime("%Y-%m-%d %H:%M:%S"),
            "actualizado":datetime.fromisoformat(p['_source']['listing']['dates']['updated']).strftime("%Y-%m-%d %H:%M:%S"),
            "antiguedad":p['_source']['listing']['age']['name'],
            "descripcion":p['_source']['listing']['description']
        }
      except:
        continue

      res.append(property_data)

    df = pd.json_normalize(res)

    df['url'] = 'https://www.fincaraiz.com.co/inmueble/'+df['tipo_propiedad']+'-en-'+df['tipo']+'/'+df['barrio']+'/'+df['ciudad']+'/'+df['id_propiedad'].astype(str)

    df.to_csv(r'/tmp/scrap-page-{}-{}.csv'.format(city,max_price), encoding='utf-8', index=False, header=True)

    self.save_data_gcs(bucket_name,r'/tmp/scrap-page-{}-{}.csv'.format(city,max_price),'scrap-page{}-{}.csv'.format(city,max_price))

    return True
  
  def make_list(self, min_price: int, max_price: int):
    multiplier = 100000000
    partitions = (max_price-min_price)/multiplier
    home_prices = []
    value = min_price
    for i in range(math.ceil(partitions)):
      if value >= max_price:
        break
      if value >= multiplier*10 and value < multiplier*25:
        home_prices.extend([value,value+500000000])
        value += 500000000
      elif value >= 2500000000:
        home_prices.extend([value,value+20000000000])
        break
      else:
        home_prices.extend([value,value+multiplier])
        value += multiplier

    list_prices = sorted(list(set(home_prices)))
    return list_prices

  def extract_data(self, bucket_name: str, city: str, min_price: int, max_price: int):
    if city not in ['bogota','medellin','barranquilla','cali']:
      self.struct_data(bucket_name, city, min_price, max_price)
    else:
      home_prices = self.make_list(min_price,max_price)
      for i in range(len(home_prices)):
        try:
          self.struct_data(bucket_name, city, home_prices[i], home_prices[i+1])
          time.sleep(15)
        except IndexError:
          pass

    return True

if __name__ == "__main__":
    Scraper().extract_data('bogota',300000000,500000000)
