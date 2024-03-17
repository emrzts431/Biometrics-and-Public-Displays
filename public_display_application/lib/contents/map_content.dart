import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/models/address_item.dart';
import 'package:http/http.dart' as http;
import 'package:public_display_application/services/navigation_service.dart';
import 'package:public_display_application/services/service_locator.dart';
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

  AddressItem? selectedAddress;
  String? selectedItemName;
  String? selectedItemAddress;
  String? duration;
  String? distance;
  List<String> instructions = [];

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
                hint: Text(S.of(context).chooseABuilding),
                value: selectedItemName,
                onChanged: (value) async {
                  debugPrint(value);
                  await userViewModel.removeAllPreferencesOfType(
                      PreferenceTypes.map,
                      locator<NavigationService>()
                          .navigatorKey
                          .currentContext!);
                  await userViewModel.setPreference(
                      PreferenceTypes.map,
                      value!,
                      locator<NavigationService>()
                          .navigatorKey
                          .currentContext!);
                },
              ),
              if (selectedAddress != null)
                const SizedBox(
                  height: 20,
                ),
              if (selectedAddress != null)
                Image.asset('assets/map_images/${selectedAddress!.img}'),
            ],
          ),
        );
      },
    );
  }
}
