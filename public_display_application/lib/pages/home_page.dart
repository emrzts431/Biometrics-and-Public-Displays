import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/dialogs/sure_to_end_session.dart';
import 'package:public_display_application/dialogs/sus_form.dart';
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
  List<String> languages = ['de', 'en'];
  String? selectedLanguage;
  @override
  void initState() {
    selectedLanguage = languages[0];
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
              : const SizedBox.shrink(),
          DropdownButton<String>(
            items: languages
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            value: selectedLanguage,
            onChanged: (value) async {
              if (value == 'en') {
                await S.load(const Locale('en', 'EN'));
              } else {
                await S.load(const Locale('de', 'DE'));
              }
              setState(() => selectedLanguage = value);
            },
          ),
        ],
      ),
      body: Listener(
        onPointerDown: (e) async {
          // print(e.pressure);
          int x = e.position.dx.round();
          int y = (e.position.dy).round();

          context.read<SessionViewModel>().updateLastTouch();
          await LogFile.of(context).logInput(x, y, e.pointer, DOWN);
        },
        onPointerMove: (e) async {
          // print(e.pressure);
          // print(e.pressureMax);
          // print(e.pressureMin);
          int x = e.position.dx.round();
          int y = (e.position.dy).round();

          await LogFile.of(context).logInput(x, y, e.pointer, MOVE);
        },
        onPointerUp: (e) async {
          // print(e.pressure);
          int x = e.position.dx.round();
          int y = (e.position.dy).round();

          await LogFile.of(context).logInput(x, y, e.pointer, UP);
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
                  Text(
                    S.of(context).workConducted,
                    style: const TextStyle(
                      fontSize: 8,
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
        ),
      ),
    );
  }
}
