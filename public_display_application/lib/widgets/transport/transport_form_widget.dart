import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/contents/transport_content.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/events/button_click_event.dart';
import 'package:public_display_application/events/pd_event_bus.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/services/navigation_service.dart';
import 'package:public_display_application/services/service_locator.dart';
import 'package:public_display_application/snackbar_holder.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class TransportFormWidget extends StatefulWidget {
  List<String> rheinischerPlatzSelectedLines;
  List<String> viehoferPlatzSelectedLines;
  TransportFormWidget({
    required this.rheinischerPlatzSelectedLines,
    required this.viehoferPlatzSelectedLines,
  });
  @override
  createState() => TransportFormWidgetState();
}

class TransportFormWidgetState extends State<TransportFormWidget> {
  List<String> rheinischerPlatzLines = [
    '101',
    '103',
    '105',
    '106',
    '109',
    '145',
    '196',
    'NE11',
    'NE12'
  ];
  List<String> viehoferPlatzLines = [
    '107',
    '108',
    '145',
    '154',
    '155',
    '196',
    'NE1',
    'NE11',
    'NE12',
    'NE2'
  ];
  List<String> viehoferPlatzSelectedLines = [];
  List<String> rheinischerPlatzSelectedLines = [];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      viehoferPlatzSelectedLines = widget.viehoferPlatzSelectedLines;
      rheinischerPlatzSelectedLines = widget.rheinischerPlatzSelectedLines;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            S.of(context).yourPreferences,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text('${S.of(context).favoriteLines} Viehoferplatz'),
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns in the grid
                crossAxisSpacing: 2.0, // Spacing between columns
                mainAxisSpacing: 2.0, // Spacing between rows
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                bool itemSelected = viehoferPlatzSelectedLines.any(
                  (element) => element == viehoferPlatzLines[index],
                );
                return GestureDetector(
                  onTap: () {
                    PDEventBus().fire(
                      ButtonClickedEvent(Buttons.lineSelection.index),
                    );
                    setState(() {
                      if (itemSelected) {
                        viehoferPlatzSelectedLines
                            .remove(viehoferPlatzLines[index]);
                      } else {
                        viehoferPlatzSelectedLines
                            .add(viehoferPlatzLines[index]);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: itemSelected ? Colors.red : Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Text(
                      viehoferPlatzLines[index],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text('${S.of(context).favoriteLines} Rheinischerplatz'),
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns in the grid
                crossAxisSpacing: 2.0, // Spacing between columns
                mainAxisSpacing: 2.0, // Spacing between rows
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                bool itemSelected = rheinischerPlatzSelectedLines.any(
                  (element) => element == rheinischerPlatzLines[index],
                );
                return GestureDetector(
                  onTap: () {
                    PDEventBus().fire(
                      ButtonClickedEvent(Buttons.lineSelection.index),
                    );
                    setState(() {
                      if (itemSelected) {
                        rheinischerPlatzSelectedLines
                            .remove(rheinischerPlatzLines[index]);
                      } else {
                        rheinischerPlatzSelectedLines
                            .add(rheinischerPlatzLines[index]);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: itemSelected ? Colors.red : Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Text(
                      rheinischerPlatzLines[index],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              PDEventBus().fire(
                ButtonClickedEvent(Buttons.save.index),
              );
              if (rheinischerPlatzSelectedLines.isEmpty &&
                  viehoferPlatzSelectedLines.isEmpty) {
                SnackbarHolder.showFailureSnackbar(
                  S.of(context).pleaseGiveALineForBothStops,
                  context,
                );
              } else {
                await locator<NavigationService>()
                    .navigatorKey
                    .currentContext!
                    .read<UserViewModel>()
                    .removeAllPreferencesOfType(
                        PreferenceTypes.transport,
                        locator<NavigationService>()
                            .navigatorKey
                            .currentContext!)
                    .then((value) async {
                  for (final line in viehoferPlatzSelectedLines) {
                    await locator<NavigationService>()
                        .navigatorKey
                        .currentContext!
                        .read<UserViewModel>()
                        .setPreference(
                            PreferenceTypes.transport,
                            "{\"V\": \"$line\"}",
                            locator<NavigationService>()
                                .navigatorKey
                                .currentContext!);
                  }
                }).then((value) async {
                  for (final line in rheinischerPlatzSelectedLines) {
                    await locator<NavigationService>()
                        .navigatorKey
                        .currentContext!
                        .read<UserViewModel>()
                        .setPreference(
                            PreferenceTypes.transport,
                            "{\"R\": \"$line\"}",
                            locator<NavigationService>()
                                .navigatorKey
                                .currentContext!);
                  }
                }).then((value) => locator<NavigationService>()
                        .navigatorKey
                        .currentContext!
                        .read<UserViewModel>()
                        .updateTransportLines = false);
                ;
              }
            },
            child: Text(S.of(context).save),
          ),
        ],
      ),
    );
  }
}
