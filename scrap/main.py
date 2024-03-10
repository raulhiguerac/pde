from scraper import Scraper
from flask import Flask
from flask_restful import reqparse

import json
import os

app = Flask(__name__)

def run_scraper(bucket_name,n_elements,first_page,last_page):
    FrScraper  = Scraper()
    FrScraper.extract_data(bucket_name,n_elements,first_page,last_page)

    return True

@app.route("/", methods=["POST"])
def main():
    parser = reqparse.RequestParser(bundle_errors=True)
    parser.add_argument("bucket_name", type=str, required= True, location="args", help='The bucket name in gcs to store the scraped files')
    parser.add_argument("n_elements" , type=int, required= True, location="args", help='Number of elements that the scraper request to the API')
    parser.add_argument("first_page" , type=int, required= True, location="args", help='Number of first page that scraper request to the API')
    parser.add_argument("last_page"  , type=int, required= True, location="args", help='Number of last page that scraper request to the API')

    args = parser.parse_args()

    run_scraper(args.bucket_name,args.n_elements,args.first_page,args.last_page)

    return json.dumps({'success':True}), 200, {'ContentType':'application/json'} 

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))

