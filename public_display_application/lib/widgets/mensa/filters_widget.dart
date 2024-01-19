import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
import 'package:public_display_application/widgets/mensa/filter_object_widget.dart';

class FiltersWidget extends StatefulWidget {
  @override
  createState() => FiltersWidgetState();
}

class FiltersWidgetState extends State<FiltersWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return Container(
          height: 50,
          width: 600,
          color: Colors.grey,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userViewModel.mensaPreference?.values.length ?? 0,
                  itemBuilder: (context, index) {
                    return FilterObject(
                      filter: userViewModel.mensaPreference!.values[index],
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Container(
                        alignment: Alignment.center,
                        height: 400,
                        width: 600,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Was ist dein Diet?'),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                      title: const Text('Kein Schwein'),
                                      onTap: () async {
                                        if (userViewModel
                                                .mensaPreference?.values
                                                .contains('no_pork') ==
                                            false) {
                                          userViewModel.setPreference(
                                              PreferenceTypes.mensa,
                                              'no_pork',
                                              context);
                                        } else {
                                          //remove preference
                                        }
                                      }),
                                  ListTile(
                                      title: const Text('Vegan'),
                                      onTap: () async {
                                        if (userViewModel
                                                .mensaPreference?.values
                                                .contains('vegan') ==
                                            false) {
                                          print('setting up vegan');
                                          userViewModel.setPreference(
                                              PreferenceTypes.mensa,
                                              'vegan',
                                              context);
                                        } else {
                                          //remove refernce
                                        }
                                      }),
                                  ListTile(
                                      title: const Text('Kein Alkohol'),
                                      onTap: () async {
                                        if (userViewModel
                                                .mensaPreference?.values
                                                .contains('no_alcohol') ==
                                            false) {
                                          userViewModel.setPreference(
                                              PreferenceTypes.mensa,
                                              'no_alcohol',
                                              context);
                                        } else {
                                          //remove reference
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.plus_circle),
              )
            ],
          ),
        );
      },
    );
  }
}
