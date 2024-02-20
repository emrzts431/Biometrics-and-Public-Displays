import 'dart:io';

import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/dialogs/sure_to_end_session.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/log_file.dart';
import 'package:public_display_application/pages/button_layout.dart';
import 'package:public_display_application/pages/no_session_zone.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  String DOWN = "1,0,0";
  String MOVE = "0,1,0";
  String UP = "0,0,1";
  int version = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          context.watch<UserViewModel>().user != null
              ? ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SureToEndSessionDialog(),
                  ),
                  child: Text(S.of(context).endSession),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: Listener(
          onPointerDown: (e) async {
            int x = e.position.dx.round();
            int y = (e.position.dy).round();

            LogFile.of(context).logInput(x, y, e.pointer, DOWN, -1);
            context.read<SessionViewModel>().updateLastTouch();
          },
          onPointerMove: (e) async {
            int x = e.position.dx.round();
            int y = (e.position.dy).round();

            LogFile.of(context).logInput(x, y, e.pointer, MOVE, -1);
          },
          onPointerUp: (e) async {
            int x = e.position.dx.round();
            int y = (e.position.dy).round();

            LogFile.of(context).logInput(x, y, e.pointer, UP, -1);
          },
          child: FooterView(
            flex: 10,
            footer: Footer(
              alignment: Alignment.bottomCenter,
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/uniicon.jpg',
                      scale: 15,
                    ),
                    const Text(
                      'This work is conducted by the HCI Team, supervised by Prof. Dr. Stefan Schneegaß',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            children: [
              const SizedBox(
                height: 80,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    height: 700,
                    width: 570,
                    child: context.watch<UserViewModel>().user != null
                        ? ButtonLayout(
                            version: 1,
                          )
                        : NoSessionZone(),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
