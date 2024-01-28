import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class MensaFilterObject extends StatelessWidget {
  String filter;
  MensaFilterObject({required this.filter});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
        color: const Color.fromARGB(181, 194, 193, 193),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(setUpFilterName()),
          IconButton(
            onPressed: () async {
              await context
                  .read<UserViewModel>()
                  .removePreference(PreferenceTypes.mensa, filter, context);
            },
            icon: const Icon(CupertinoIcons.trash),
          ),
        ],
      ),
    );
  }

  String setUpFilterName() {
    switch (filter) {
      case 'S':
        return 'mit Schweinfleisch';
      case 'R':
        return 'mit Rindfleisch';
      case 'VEG':
        return 'Vegan';
      case 'A':
        return 'mit Alkohol';
      case 'G':
        return 'mit Geflügel';
      case 'F':
        return 'mit Fisch';
      case 'V':
        return 'Vegetarisch';
      default:
        return 'unknown';
    }
  }
}
