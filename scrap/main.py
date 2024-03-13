from scraper import Scraper
from flask import Flask
from flask_restful import reqparse

import json
import os

app = Flask(__name__)

def run_scraper(bucket_name, city, min_price, max_price):
    FrScraper  = Scraper()
    FrScraper.extract_data(bucket_name, city, min_price, max_price)

    return True

@app.route("/", methods=["POST"])
def main():
    parser = reqparse.RequestParser(bundle_errors=True)
    parser.add_argument("bucket_name", type=str, required= True, location="args", help='The bucket name in gcs to store the scraped files')
    parser.add_argument("city" , type=str, required= True, location="args", help='Name of the city that the scraper request to the API')
    parser.add_argument("min_price" , type=int, required= True, location="args", help='Min price that scraper request to the API')
    parser.add_argument("max_price"  , type=int, required= True, location="args", help='Max price that scraper request to the API')

    args = parser.parse_args()

    run_scraper(args.bucket_name,args.city,args.min_price,args.max_price)

    return json.dumps({'success':True}), 200, {'ContentType':'application/json'} 

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))

