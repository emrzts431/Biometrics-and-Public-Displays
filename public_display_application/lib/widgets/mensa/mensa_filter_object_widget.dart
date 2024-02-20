import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/generated/l10n.dart';
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
          Text(setUpFilterName(context)),
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

  String setUpFilterName(BuildContext context) {
    switch (filter) {
      case 'S':
        return S.of(context).withPork;
      case 'R':
        return S.of(context).withBeef;
      case 'VEG':
        return S.of(context).vegan;
      case 'A':
        return S.of(context).withAlcohol;
      case 'G':
        return S.of(context).withPoultry;
      case 'F':
        return S.of(context).withFish;
      case 'V':
        return S.of(context).vegetarien;
      default:
        return S.of(context).unknown;
    }
  }
}
