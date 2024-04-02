import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/models/transportline_item.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
import 'package:public_display_application/widgets/transport/transport_form_widget.dart';
import 'package:public_display_application/widgets/transport/transport_icon.dart';
import 'package:public_display_application/widgets/transport/transport_times.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TransportContent extends StatefulWidget {
  Map<String, List<TransportLineItem>> data;
  TransportContent({super.key, required this.data});

  @override
  State<StatefulWidget> createState() {
    return TransportContentState();
  }
}

class TransportContentState extends State<TransportContent> {
  final _viehoferplatzcontroller = ScrollController();
  final _rheinischerplatzcontroller = ScrollController();
  final _pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(context.read<UserViewModel>().user!.userid);
      context
          .read<UserViewModel>()
          .getPreference(PreferenceTypes.transport, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.transportPreference == null ||
            userViewModel.updateTransportLines) {
          if (userViewModel.transportPreference == null) {
            return TransportFormWidget(
              rheinischerPlatzSelectedLines: [],
              viehoferPlatzSelectedLines: [],
            );
          } else {
            List<String> rheinischerPlatzItems = [];
            List<String> viehoferPlatzItems = [];
            for (final item in userViewModel.transportPreference!.values) {
              final itemJson = jsonDecode(item) as Map<String, dynamic>;
              if (itemJson.containsKey('V')) {
                viehoferPlatzItems.add(itemJson['V']);
              } else {
                rheinischerPlatzItems.add(itemJson['R']);
              }
            }

            return TransportFormWidget(
              rheinischerPlatzSelectedLines: rheinischerPlatzItems,
              viehoferPlatzSelectedLines: viehoferPlatzItems,
            );
          }
        } else {
          List<String> rheinischerPlatzItems = [];
          List<String> viehoferPlatzItems = [];
          for (final item in userViewModel.transportPreference!.values) {
            final itemJson = jsonDecode(item) as Map<String, dynamic>;
            if (itemJson.containsKey('V')) {
              viehoferPlatzItems.add(itemJson['V']!);
            } else {
              rheinischerPlatzItems.add(itemJson['R']!);
            }
          }

          return Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 550,
                  width: 400,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Viehoferplatz',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => setState(() =>
                                userViewModel.updateTransportLines = true),
                            child: Text(S.of(context).changeLinePreference),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _viehoferplatzcontroller,
                              child: ListView.builder(
                                controller: _viehoferplatzcontroller,
                                itemCount: widget.data['V']!.length,
                                itemBuilder: (context, index) {
                                  TransportLineItem item =
                                      widget.data['V']![index];
                                  if (viehoferPlatzItems
                                      .contains(item.number)) {
                                    return ListTile(
                                      leading: TransportTimes(
                                        item: item,
                                      ),
                                      title: Row(
                                        children: [
                                          TransportIcon(
                                              type: item.transportType),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Text("${item.number}"),
                                        ],
                                      ),
                                      subtitle: Text(item.direction),
                                      trailing: Text(item.platformName),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Rheinischerplatz',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => setState(() =>
                                userViewModel.updateTransportLines = true),
                            child: Text(S.of(context).changeLinePreference),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _rheinischerplatzcontroller,
                              child: ListView.builder(
                                controller: _rheinischerplatzcontroller,
                                itemCount: widget.data['R']!.length,
                                itemBuilder: (context, index) {
                                  TransportLineItem item =
                                      widget.data['R']![index];
                                  if (rheinischerPlatzItems
                                      .contains(item.number)) {
                                    return ListTile(
                                      leading: TransportTimes(
                                        item: item,
                                      ),
                                      title: Row(
                                        children: [
                                          TransportIcon(
                                              type: item.transportType),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Text(item.number),
                                        ],
                                      ),
                                      subtitle: Text(item.direction),
                                      trailing: Text(item.platformName),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  onDotClicked: (index) => _pageController.animateToPage(
                    index,
                    duration: const Duration(seconds: 1),
                    curve: Curves.decelerate,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
