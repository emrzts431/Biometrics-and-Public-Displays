import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
import 'package:public_display_application/widgets/mensa/mensa_filter_object_widget.dart';

class MensaFiltersWidget extends StatefulWidget {
  @override
  createState() => MensaFiltersWidgetState();
}

class MensaFiltersWidgetState extends State<MensaFiltersWidget> {
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
                    return MensaFilterObject(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Was ist dein Diet?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                    title: const Text('mit Schweinfleisch'),
                                    onTap: () async {
                                      print('pork');
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('S') ==
                                              false) {
                                        print('setting up pork');
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'S',
                                            context);
                                      } else {
                                        //remove preference
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Vegan'),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('VEG') ==
                                              false) {
                                        print('setting up vegan');
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'VEG',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('mit Alkohol'),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('A') ==
                                              false) {
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'A',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('mit Rindfleisch'),
                                    onTap: () async {
                                      print('rind');
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('R') ==
                                              false) {
                                        print('setting up rind');
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'R',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('mit Geflügel'),
                                    onTap: () async {
                                      print('geflügel');
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('G') ==
                                              false) {
                                        print('setting up geflügel');
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'G',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('mit Fisch'),
                                    onTap: () async {
                                      print('Fisch');
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('F') ==
                                              false) {
                                        print('setting up Fisch');
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'F',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Vegetarisch'),
                                    onTap: () async {
                                      print('Vegetarisch');
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('V') ==
                                              false) {
                                        print('setting up Vegetarisch');
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'V',
                                            context);
                                      }
                                    },
                                  ),
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
