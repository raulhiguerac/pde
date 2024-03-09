from scraper import Scraper

import argparse

def run_scraper(bucket_name,n_elements,first_page,last_page):
    FrScraper  = Scraper()
    FrScraper.extract_data(bucket_name,n_elements,first_page,last_page)

    return True

def main():
    parser = argparse.ArgumentParser(description='Extract data from Colombian property listings')
    parser.add_argument("--bucket_name", type=str, required= True, help='The bucket name in gcs to store the scraped files')
    parser.add_argument("--n_elements" , type=int, required= True, help='Number of elements that the scraper request to the API')
    parser.add_argument("--first_page" , type=int, required= True, help='Number of first page that scraper request to the API')
    parser.add_argument("--last_page"  , type=int, required= True, help='Number of last page that scraper request to the API')

    args = parser.parse_args()

    run_scraper(args.bucket_name,args.n_elements,args.first_page,args.last_page)

if __name__ == "__main__":
    main()

