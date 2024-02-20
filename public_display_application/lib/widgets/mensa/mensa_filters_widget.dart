import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/generated/l10n.dart';
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
                            Text(
                              S.of(context).whatIsYourDiet,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                    title: Text(S.of(context).withPork),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('S') ==
                                              false) {
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'S',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: Text(S.of(context).vegan),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('VEG') ==
                                              false) {
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'VEG',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: Text(S.of(context).withAlcohol),
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
                                    title: Text(S.of(context).withBeef),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('R') ==
                                              false) {
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'R',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: Text(S.of(context).withPoultry),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('G') ==
                                              false) {
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'G',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: Text(S.of(context).withFish),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('F') ==
                                              false) {
                                        await userViewModel.setPreference(
                                            PreferenceTypes.mensa,
                                            'F',
                                            context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: Text(S.of(context).vegetarien),
                                    onTap: () async {
                                      if (userViewModel.mensaPreference ==
                                              null ||
                                          userViewModel.mensaPreference?.values
                                                  .contains('V') ==
                                              false) {
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
