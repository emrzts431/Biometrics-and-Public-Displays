import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:public_display_application/contents/map_content.dart';
import 'package:public_display_application/contents/mensa_content.dart';
import 'package:public_display_application/contents/transport_content.dart';
import 'package:public_display_application/contents/weather_content.dart';
import 'package:public_display_application/dialogs/sus_form.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/events/button_click_event.dart';
import 'package:public_display_application/events/pd_event_bus.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/models/address_item.dart';
import 'package:public_display_application/models/speiseplan_item.dart';
import 'package:public_display_application/models/transportline_item.dart';
import 'package:public_display_application/models/weather_item.dart';
import 'package:public_display_application/services/navigation_service.dart';
import 'package:public_display_application/services/service_locator.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
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
  String? contentString;
  Elements selectedElement = Elements.none;
  var data;
  final _controller = PageController();
  List<bool> visitedContents = [false, false, false, false];

  @override
  void initState() {
    debugPrint("Currently at ButtonLayout");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SessionViewModel>().startRestartPeriodicChecks(context);
      context.read<SessionViewModel>().openContentScreen();
      context.read<UserViewModel>().setHomePageContext(context);
    });
    super.initState();
  }

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
                        fontSize: 24,
                      ),
                    ),
                  );
                },
              )
            : Column(
                children: [
                  SizedBox(
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
                              fontSize: 20,
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
                    onDotClicked: (index) => _controller.animateToPage(
                      index,
                      duration: const Duration(seconds: 1),
                      curve: Curves.decelerate,
                    ),
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
              if (selectedElement == Elements.mensa)
                MensaContent(
                  data: data,
                ),
              if (selectedElement == Elements.transport)
                TransportContent(data: data),
              if (selectedElement == Elements.weather)
                WeatherContent(data: data),
              if (selectedElement == Elements.map)
                MapContent(
                  data: data,
                ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                ),
                onPressed: () async {
                  PDEventBus().fire(
                    ButtonClickedEvent(Buttons.goBackHomePage.index),
                  );
                  if (!visitedContents.any((element) => element == false)) {
                    int numberOfVisitsForUser = await context
                        .read<UserViewModel>()
                        .getNumberOfVisits(context);
                    if (numberOfVisitsForUser == 1.0 ||
                        numberOfVisitsForUser == 5.0) {
                      showDialog(
                        barrierDismissible: false,
                        context: locator<NavigationService>()
                            .navigatorKey
                            .currentContext!,
                        builder: (context) => SUSForm(),
                      );
                    }
                    setState(() {
                      selectedElement = Elements.none;
                      data = null;
                      context.read<UserViewModel>().updateTransportLines =
                          false;
                    });
                  } else {
                    setState(() {
                      selectedElement = Elements.none;
                      data = null;
                      context.read<UserViewModel>().updateTransportLines =
                          false;
                    });
                  }
                },
                child: Text(
                  S.of(context).goBack,
                  style: const TextStyle(
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
        await getMensaData();
        break;
      case 1:
        await getDataViehoferPlatz();
        break;
      case 2:
        await getMapData();
        break;
      case 3:
        await getWeatherInfo();
        break;
      default:
        print("WTF?");
    }
  }

  String buttonName(int index) {
    switch (index) {
      case 0:
        return S.of(context).canteen;
      case 1:
        return S.of(context).transport;
      case 2:
        return S.of(context).map;
      case 3:
        return S.of(context).weather;
      default:
        return "Unknown";
    }
  }

  Future getMensaData() async {
    PDEventBus().fire(
      ButtonClickedEvent(Buttons.canteen.index),
    );
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
    final tags_iterable = document.findAllElements('tag').toList();
    Map<int, List<SpeisePlanItem>> localData = {};
    for (final tag in tags_iterable) {
      int curKey = int.parse(tag.attributes.first.value);
      localData[curKey] = [];
      final tagItems = tag.findAllElements('item').toList();
      for (final item in tagItems) {
        SpeisePlanItem si = setUpItem(item);
        if (si.title != "geschlossen") {
          localData[curKey]!.add(setUpItem(item));
        }
      }
    }
    Navigator.pop(locator<NavigationService>().navigatorKey.currentContext!);
    setState(() {
      visitedContents[0] = true;
      data = localData;
      selectedElement = Elements.mensa;
      contentString = S.of(context).canteenMenu;
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
                : desElement.innerText.replaceFirst(
                    ',',
                    '.',
                  ),
          );
        case "preis2":
          item.preis2 = double.parse(
            desElement.innerText == "null" || desElement.innerText.isEmpty
                ? "0.0"
                : desElement.innerText.replaceFirst(
                    ',',
                    '.',
                  ),
          );
        case "preis3":
          item.preis3 = double.parse(
            desElement.innerText == "null" || desElement.innerText.isEmpty
                ? "0.0"
                : desElement.innerText.replaceFirst(
                    ',',
                    '.',
                  ),
          );
        case "aktion":
          item.aktion = desElement.innerText;
        case "nutriscore":
          item.nutriscore = desElement.innerText;
        case "foto":
          item.foto = desElement.innerText;
        case "naehrwerte":
          item.nutritionScores =
              setUpNutritionScores(desElement.childElements.first);
      }
    }
    return item;
  }

  NutritionScores setUpNutritionScores(XmlElement portion) {
    NutritionScores scores = NutritionScores();
    for (final value in portion.descendantElements) {
      switch (value.localName) {
        case "kj":
          scores.kj = double.parse(value.innerText);
        case "kcal":
          scores.kcal = double.parse(value.innerText);
        case "eiweiss":
          scores.protein = double.parse(value.innerText);
        case "fett":
          scores.fat = double.parse(value.innerText);
        case "gesfett":
          scores.transfat = double.parse(value.innerText);
        case "zucker":
          scores.sugar = double.parse(value.innerText);
        case "ballaststoffe":
          scores.ballastoffe = double.parse(value.innerText);
        case "salz":
          scores.salz = double.parse(value.innerText);
        case "kh":
          scores.carbonhydrate = double.parse(value.innerText);
      }
    }
    return scores;
  }

  Future getDataViehoferPlatz() async {
    PDEventBus().fire(
      ButtonClickedEvent(Buttons.transport.index),
    );
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    final transportInfoListViehofer = await getDepartureList('20009619');
    final transportInfoListRheinischer = await getDepartureList('20009712');
    Map<String, List<TransportLineItem>> localData = {
      'V': transportInfoListViehofer,
      'R': transportInfoListRheinischer
    };
    Navigator.pop(locator<NavigationService>().navigatorKey.currentContext!);
    setState(() {
      visitedContents[1] = true;
      data = localData;
      selectedElement = Elements.transport;
      contentString = S.of(context).transportation;
    });
  }

  Future<List<TransportLineItem>> getDepartureList(String stopid) async {
    String departureUrlString = "https://ifa.ruhrbahn.de/departure/$stopid";
    final departuresUrl = Uri.parse(departureUrlString);
    final response = await http.get(departuresUrl);
    final departureListJson = jsonDecode(response.body);
    final departureList =
        departureListJson['data']['departureList'] as List<dynamic>?;
    List<TransportLineItem> transportInfoList = [];
    for (final departure in departureList ?? []) {
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
    return transportInfoList;
  }

  Future getWeatherInfo() async {
    PDEventBus().fire(
      ButtonClickedEvent(Buttons.weather.index),
    );
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
    Navigator.pop(locator<NavigationService>().navigatorKey.currentContext!);
    setState(() {
      visitedContents[2] = true;
      selectedElement = Elements.weather;
      data = weatherItemList;
      contentString = "Essen ${S.of(context).weather}";
    });
  }

  Future getMapData() async {
    PDEventBus().fire(
      ButtonClickedEvent(Buttons.map.index),
    );
    String fileData = await DefaultAssetBundle.of(context)
        .loadString("assets/address_list.json");
    final jsonResult = jsonDecode(fileData);
    List<AddressItem> addressList = [];
    for (final json_i in jsonResult) {
      AddressItem item = AddressItem.fromJson(json_i);
      addressList.add(item);
    }
    setState(() {
      visitedContents[3] = true;
      selectedElement = Elements.map;
      data = addressList;
      contentString = S.of(context).map;
    });
  }
}
