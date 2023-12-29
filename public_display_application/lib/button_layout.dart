import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:public_display_application/contents/mensa_content.dart';
import 'package:public_display_application/contents/transport_content.dart';
import 'package:public_display_application/contents/weather_content.dart';
import 'package:public_display_application/models/speiseplan_item.dart';
import 'package:public_display_application/models/transportline_item.dart';
import 'package:public_display_application/models/weather_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xml/xml.dart';

enum Elements {
  mensa,
  transport,
  map,
  weather,
  none,
}

class ButtonLayout extends StatefulWidget {
  int version;
  ButtonLayout({required this.version});
  @override
  State<StatefulWidget> createState() {
    return ButtonLayoutState();
  }
}

class ButtonLayoutState extends State<ButtonLayout> {
  String? contentString = null;
  dom.Element? doc;
  Elements selectedElement = Elements.none;
  var data;
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return selectedElement == Elements.none
        ? widget.version == 1
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 15, // Spacing between columns
                  mainAxisSpacing: 15.0, // Spacing between rows
                  childAspectRatio: 1.1,
                ),
                itemCount: 4, // Number of items in the grid
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () => buttonFunctionality(index),
                    child: Text(
                      buttonName(index),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              )
            : Column(
                children: [
                  Container(
                    width: 400,
                    height: 550,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(),
                          ),
                          onPressed: () => buttonFunctionality(index),
                          child: Text(
                            buttonName(index),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    onDotClicked: (index) => _controller.jumpToPage(index),
                  ),
                ],
              )
        : Column(
            children: [
              if (contentString != null)
                Text(
                  contentString!,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (contentString != null)
                const SizedBox(
                  height: 20,
                ),
              if (selectedElement == Elements.mensa) MensaContent(data: data),
              if (selectedElement == Elements.transport)
                TransportContent(data: data),
              if (selectedElement == Elements.weather)
                WeatherContent(data: data),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                ),
                onPressed: () => setState(() {
                  selectedElement = Elements.none;
                  data = null;
                }),
                child: const Text(
                  "Zurückgehen",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
  }

  void buttonFunctionality(int index) async {
    switch (index) {
      case 0:
        print("Mensa");
        await getMensaData();
      case 1:
        print("Transport");
        await getDataViehoferPlatz();
      case 2:
        print("Map");
      case 3:
        print("Weather");
        await getWeatherInfo();
      default:
        print("WTF?");
    }
  }

  String buttonName(int index) {
    switch (index) {
      case 0:
        return "Mensa";
      case 1:
        return "Transport";
      case 2:
        return "Map";
      case 3:
        return "Wetter";
      default:
        return "Unknown";
    }
  }

  Future getMensaData() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    List<SpeisePlanItem> speisePlanList = [];
    var url = Uri.parse(
        'https://www.stw-edu.de/gastronomie/speiseplaene/mensa-campus-essen');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final element = html.getElementById('speisejs');
    final api_url = element?.attributes['data-url'] != null
        ? "https://www.stw-edu.de${element!.attributes['data-url']!}"
        : "";
    print(api_url);
    url = Uri.parse(api_url);
    final response_data = await http.get(url);
    final document = XmlDocument.parse(response_data.body);
    final items_iterable = document.findAllElements('item').toList();
    for (final item in items_iterable) {
      SpeisePlanItem si = setUpItem(item);
      if (si.title != "geschlossen") {
        speisePlanList.add(setUpItem(item));
      }
    }
    Navigator.pop(
        context); //TODO: Handle this using locator or navigation service
    setState(() {
      data = speisePlanList;
      selectedElement = Elements.mensa;
      contentString = "Mensa Speiseplan";
    });
  }

  SpeisePlanItem setUpItem(XmlElement element) {
    SpeisePlanItem item = SpeisePlanItem();
    for (final desElement in element.descendantElements) {
      switch (desElement.name.local) {
        case "title":
          item.title = desElement.innerText;
        case "description":
          item.description = desElement.innerText;
        case "category":
          item.category = desElement.innerText;
        case "category_en":
          item.category_en = desElement.innerText;
        case "title_en":
          item.title_en = desElement.innerText;
        case "description_en":
          item.description_en = desElement.innerText;
        case "kennz_gesetzl":
          item.kennz_gesetzl = desElement.innerText;
        case "kennz_icons":
          item.kennz_icons = desElement.innerText;
        case "kennz_allergen":
          item.kennz_allergen = desElement.innerText;
        case "preis1":
          item.preis1 = double.parse(
              desElement.innerText == "null" || desElement.innerText.isEmpty
                  ? "0.0"
                  : desElement.innerText);
        case "preis2":
          item.preis2 = double.parse(
              desElement.innerText == "null" || desElement.innerText.isEmpty
                  ? "0.0"
                  : desElement.innerText);
        case "preis3":
          item.preis3 = double.parse(
              desElement.innerText == "null" || desElement.innerText.isEmpty
                  ? "0.0"
                  : desElement.innerText);
        case "aktion":
          item.aktion = desElement.innerText;
        case "nutriscore":
          item.nutriscore = desElement.innerText;
        case "foto":
          item.nutriscore = desElement.innerText;
      }
    }
    return item;
  }

  Future getDataViehoferPlatz() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    const departuresUrlString = "https://ifa.ruhrbahn.de/departure/20009619";
    final departuresUrl = Uri.parse(departuresUrlString);
    final response = await http.get(departuresUrl);
    final departureListJson = jsonDecode(response.body);
    final departureList = departureListJson['data']['departureList'];
    List<TransportLineItem> transportInfoList = [];
    for (final departure in departureList) {
      TransportLineItem transportLineItem = TransportLineItem(
        platformName: departure['platformName'],
        realtimeTripStatus: departure['realtimeTripStatus'] == "MONITORED"
            ? TransportStatus.monitored
            : TransportStatus.tripCancelled,
        dateTime: DateTime(
          int.parse(departure['dateTime']['year']),
          int.parse(departure['dateTime']['month']),
          int.parse(departure['dateTime']['day']),
          int.parse(departure['dateTime']['hour']),
          int.parse(departure['dateTime']['minute']),
        ),
        transportType: departure['operator']['name'] == "EVAG Bus"
            ? TransportType.bus
            : TransportType.tram,
        directionFrom: departure['servingLine']['directionFrom'],
        direction: departure['servingLine']['direction'],
        number: departure['servingLine']['number'],
      );
      if (transportLineItem.realtimeTripStatus !=
              TransportStatus.tripCancelled &&
          departure.containsKey('realDateTime')) {
        transportLineItem.realDateTime = DateTime(
          int.parse(departure['realDateTime']['year']),
          int.parse(departure['realDateTime']['month']),
          int.parse(departure['realDateTime']['day']),
          int.parse(departure['realDateTime']['hour']),
          int.parse(departure['realDateTime']['minute']),
        );
      }
      transportInfoList.add(transportLineItem);
    }
    Navigator.pop(context); //TODO: Fix this with locator or Navigation Service
    setState(() {
      data = transportInfoList;
      selectedElement = Elements.transport;
      contentString = "Viehoferplatz Transport Liste";
    });
  }

  Future getWeatherInfo() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    const weatherUrlString =
        "https://api.weatherapi.com/v1/forecast.json?key=c2bd65eb8c734126b70213321232812&q=Essen&days=1&aqi=no&alerts=no";
    final url = Uri.parse(weatherUrlString);
    final response = await http.get(url);
    final responseJson = jsonDecode(response.body);
    List<WeatherItem> weatherItemList = [];
    WeatherItem current = WeatherItem(
      temperature: responseJson['current']['temp_c'],
      text: responseJson['current']['condition']['text'],
      icon: "https:${responseJson['current']['condition']['icon']}",
      time: DateTime.parse(
        responseJson['current']['last_updated'],
      ),
      regionName: responseJson['location']['region'],
      locationName: responseJson['location']['name'],
    );
    weatherItemList.add(current);
    for (final hour_forecast in responseJson['forecast']['forecastday'][0]
        ['hour']) {
      WeatherItem item = WeatherItem(
        temperature: hour_forecast['temp_c'],
        text: hour_forecast['condition']['text'],
        icon: "https:${hour_forecast['condition']['icon']}",
        time: DateTime.parse(
          hour_forecast['time'],
        ),
        regionName: responseJson['location']['region'],
        locationName: responseJson['location']['name'],
      );
      weatherItemList.add(item);
    }
    Navigator.pop(context);
    setState(() {
      selectedElement = Elements.weather;
      data = weatherItemList;
      contentString = "Essen Wetter";
    });
  }

  Future loadMapdata() async {}
}
