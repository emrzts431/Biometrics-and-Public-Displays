import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/models/address_item.dart';
import 'package:http/http.dart' as http;
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class MapContent extends StatefulWidget {
  List<AddressItem> data;

  MapContent({
    required this.data,
  });

  @override
  State<StatefulWidget> createState() {
    return MapContentState();
  }
}

class MapContentState extends State<MapContent> {
  Image? map;
  String maps_api_key = "AIzaSyBtbjZpeAY6AJSbTr7CMk5WE1WwsT5UV6U";
  // String directions_api =
  //     "https://maps.googleapis.com/maps/api/directions/json?destination=DESTINATION&origin=ORIGIN&mode=walking&key=YOUR_API_KEY&language=de&region=DE";
  // String static_map_api =
  //     "https://maps.googleapis.com/maps/api/staticmap?key=YOUR_API_KEY&MARKERS_STRING&path=enc%3APATH&size=600x300&language=de&region=DE";
  AddressItem? selectedAddress;
  String? selectedItemName;
  String? selectedItemAddress;
  String? duration;
  String? distance;
  List<String> instructions = [];
  //ScrollController _controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserViewModel>().getPreference(PreferenceTypes.map, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.mapPreference != null &&
            userViewModel.mapPreference!.values.isNotEmpty) {
          selectedItemName = userViewModel.mapPreference!.values.first;
          selectedAddress = widget.data
              .firstWhere((element) => element.name == selectedItemName);
        }
        return Expanded(
          child: Column(
            children: [
              DropdownButton<String>(
                items: widget.data
                    .map<DropdownMenuItem<String>>(
                      (AddressItem item) => DropdownMenuItem<String>(
                        value: item.name,
                        child: Text(
                          item.name,
                        ),
                      ),
                    )
                    .toList(),
                hint: const Text('Ein Geabäude auswählen'),
                value: selectedItemName,
                onChanged: (value) async {
                  print(value);
                  await userViewModel.removeAllPreferencesOfType(
                      PreferenceTypes.map, context);
                  await userViewModel.setPreference(
                      PreferenceTypes.map, value!, context);
                },
              ),
              if (selectedAddress != null)
                const SizedBox(
                  height: 20,
                ),
              if (selectedAddress != null)
                // FutureBuilder(
                //   future: getMapImage(),
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     } else {
                //       return Expanded(
                //           child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           snapshot.data,
                //           const SizedBox(
                //             height: 40,
                //           ),
                //           Container(
                //             height: 150,
                //             alignment: Alignment.center,
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Column(
                //                   crossAxisAlignment: CrossAxisAlignment.center,
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Text(
                //                       selectedAddress?.address ?? "unknown address",
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 14,
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       "Dauer: $duration",
                //                       style: const TextStyle(
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 13),
                //                     ),
                //                     const SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       "Distanz: $distance",
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 13,
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       width: 10,
                //                     ),
                //                   ],
                //                 ),
                //                 Expanded(
                //                   child: Scrollbar(
                //                     thumbVisibility: true,
                //                     interactive: true,
                //                     controller: _controller,
                //                     child: ListView.separated(
                //                       separatorBuilder: (context, index) =>
                //                           const Divider(
                //                         color: Colors.black,
                //                         thickness: 0.7,
                //                       ),
                //                       controller: _controller,
                //                       itemCount: instructions.length,
                //                       itemBuilder: (context, index) => ListTile(
                //                         leading: const Icon(
                //                           Icons.arrow_right,
                //                           color: Colors.green,
                //                           size: 30,
                //                         ),
                //                         title: HtmlWidget(instructions[index]),
                //                         trailing: Text('${index + 1}'),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ));
                //     }
                //   },
                // ),
                Image.asset('assets/map_images/${selectedAddress!.img}'),
            ],
          ),
        );
      },
    );
  }

  // Future getMapImage() async {
  //   String curLocationString = "51.462335884261435,7.017706698347373";
  //   final directionsUrl = Uri.parse(
  //     directions_api
  //         .replaceFirst(
  //           'ORIGIN',
  //           curLocationString,
  //         )
  //         .replaceFirst(
  //           'DESTINATION',
  //           '${selectedAddress!.lat},${selectedAddress!.lon}',
  //         )
  //         .replaceAll(
  //           'YOUR_API_KEY',
  //           maps_api_key,
  //         ),
  //   );
  //   final routeResponse = await http.get(directionsUrl);
  //   final routeResponseJson = jsonDecode(routeResponse.body);
  //   List<String> localInstructions = [];
  //   //Route information
  //   for (final step in routeResponseJson['routes'][0]['legs'][0]['steps']) {
  //     String instruction = step['html_instructions'];
  //     localInstructions.add(instruction);
  //   }

  //   String polyLine =
  //       routeResponseJson['routes'][0]['overview_polyline']['points'];

  //   String distance =
  //       routeResponseJson['routes'][0]['legs'][0]['distance']['text'];
  //   String duration =
  //       routeResponseJson['routes'][0]['legs'][0]['duration']['text'];
  //   //------------------

  //   //Static map information
  //   String markerString =
  //       "markers=color:blue%7Clabel:S%7C$curLocationString&markers=color:red%7Clabel:Z%7c${selectedAddress!.lat},${selectedAddress!.lon}";
  //   final staticMapUrl = Uri.parse(
  //     static_map_api
  //         .replaceFirst(
  //           'YOUR_API_KEY',
  //           maps_api_key,
  //         )
  //         .replaceFirst(
  //           'MARKERS_STRING',
  //           markerString,
  //         )
  //         .replaceFirst(
  //           'PATH',
  //           polyLine,
  //         ),
  //   );
  //   final staticMapResponse = await http.get(staticMapUrl);
  //   //---------------------
  //   if (this.distance != distance && this.duration != duration) {
  //     setState(() {
  //       this.distance = distance;
  //       this.duration = duration;
  //       instructions = localInstructions;
  //     });
  //   }
  //   return Image.memory(staticMapResponse.bodyBytes);
  // }
}
