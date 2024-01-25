import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/contents/transport_content.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/navigation_service.dart';
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
    // TODO: implement build
    return Expanded(
      child: Column(
        children: [
          Text(
            'Deine Präferenzen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text('Lieblingslinien Viehoferplatz'),
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
                  onTap: () => setState(() {
                    if (itemSelected) {
                      viehoferPlatzSelectedLines
                          .remove(viehoferPlatzLines[index]);
                    } else {
                      viehoferPlatzSelectedLines.add(viehoferPlatzLines[index]);
                    }
                  }),
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
          Text('Lieblingslinien Rheinischerplatz'),
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
                  onTap: () => setState(() {
                    if (itemSelected) {
                      rheinischerPlatzSelectedLines
                          .remove(rheinischerPlatzLines[index]);
                    } else {
                      rheinischerPlatzSelectedLines
                          .add(rheinischerPlatzLines[index]);
                    }
                  }),
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
              if (rheinischerPlatzSelectedLines.isEmpty ||
                  viehoferPlatzSelectedLines.isEmpty) {
                SnackbarHolder.showFailureSnackbar(
                    'Bitte gebe fuer beide Haltestellen deine lieblings Linien ein!',
                    context);
              } else {
                await context.read<UserViewModel>().removeAllPreferencesOfType(
                    PreferenceTypes.transport, context);
                for (final line in viehoferPlatzSelectedLines) {
                  await context.read<UserViewModel>().setPreference(
                      PreferenceTypes.transport, "{\"V\": \"$line\"}", context);
                }
                for (final line in rheinischerPlatzSelectedLines) {
                  await context.read<UserViewModel>().setPreference(
                      PreferenceTypes.transport, "{\"R\": \"$line\"}", context);
                }
                context.read<UserViewModel>().updateTransportLines = false;
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}
