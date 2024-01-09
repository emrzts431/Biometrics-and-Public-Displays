import 'dart:io';

import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:public_display_application/log_file.dart';
import 'package:public_display_application/button_layout.dart';

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

  void logInput(int x, int y, int pointer, String type) {
    String logString =
        "${DateTime.now().microsecondsSinceEpoch},$x,$y,$pointer,$type\n";

    print(LogFile.of(context).logFile);
    print(logString);
    LogFile.of(context).logFile.writeAsString(
          logString,
          mode: FileMode.append,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Listener(
          onPointerDown: (e) async {
            int x = e.position.dx.round();
            int y = (e.position.dy).round();

            logInput(x, y, e.pointer, DOWN);
          },
          onPointerMove: (e) async {
            int x = e.position.dx.round();
            int y = (e.position.dy).round();

            logInput(x, y, e.pointer, MOVE);
          },
          onPointerUp: (e) async {
            int x = e.position.dx.round();
            int y = (e.position.dy).round();

            logInput(x, y, e.pointer, UP);
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
                    child: ButtonLayout(
                      version: 2,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
