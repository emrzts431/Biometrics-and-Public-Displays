import 'package:flutter/material.dart';

class MapContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}

class MapContentState extends State<MapContent> {
  String directions_api_key = "AIzaSyBtbjZpeAY6AJSbTr7CMk5WE1WwsT5UV6U";
  String directions_api =
      "https://maps.googleapis.com/maps/api/directions/json?destination=DESTINATION&origin=ORIGIN&key=YOUR_API_KEY";
  String static_map_api =
      "https://maps.googleapis.com/maps/api/staticmap?key=AIzaSyBtbjZpeAY6AJSbTr7CMk5WE1WwsT5UV6U&markers=&path=enc%3A";
  //TODO: Step1: Create dropdown buttons to let the user select the address

  //TODO: Step2: Using the current location (a predefined coordination) and the destination (also a predefined coordination) calculate the paths

  //TODO: Step3: Using the calculated paths send the static map api the correct polyline routes, and the marker locations and show the image

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
