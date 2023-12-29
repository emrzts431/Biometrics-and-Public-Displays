import requests
from bs4 import BeautifulSoup
import bs4
import json
import threading

class Stop:
    def __init__(self, name, lat, lon) -> None:
        self.name = name
        self.lat = lat
        self.lon = lon


def stop_serializer(obj):
    if isinstance(obj, Stop):
        return {"name": obj.name, "lat": obj.lat, "lon": obj.lon}
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")
def getData(stop_i):
    name = stop_i.text.strip()
    stop_content_url = url_header + stop_i['href']
    url_site = requests.get(stop_content_url)
    soup2 = BeautifulSoup(url_site.content, "html.parser")
    stop_details_tag = soup2.find("span", class_="mbientCla_mapConfig_station")
    data_dict = json.loads(stop_details_tag.text)
    lat = data_dict['pois'][0]['lat']
    lon = data_dict['pois'][0]['lon']
    stop = Stop(name, lat, lon)
    local_stop_list.append(stop)

url_header = "https://www.ruhrbahn.de"

url_stop_list = url_header + "/essen/fahrplan/haltestellen/haltestelle/"
page = requests.get(url_stop_list)

soup = BeautifulSoup(page.content, "html.parser")

stops_links_and_names = soup.find_all("a", class_="stations-list-link")

local_stop_list = []

number_of_data_fetched = 0
lock = threading.Lock()
print(f"Number of stops: {len(stops_links_and_names)}")
i = 0
for stop_i in stops_links_and_names:
    try:
        url = url_header + stop_i['href']
        name = stop_i.text.strip()
        url_site = requests.get(url)
        soup2 = BeautifulSoup(url_site.content, "html.parser")
        stop_details_tag = soup2.find("span", class_="mbientCla_mapConfig_station")
        data_dict = json.loads(stop_details_tag.text)
        lat = data_dict['pois'][0]['lat']
        lon = data_dict['pois'][0]['lon']
        stop = Stop(name, lat, lon)
        local_stop_list.append(stop)
    except:
        print("exception here")
        continue
    i+=1
    print(i)



print("Dumping json...")
json_data = json.dumps(local_stop_list, default=stop_serializer)
with open('assets/rheinstops.js', 'w') as f:
    f.writelines(json_data)
