import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:public_display_application/home_page.dart';
import 'package:public_display_application/log_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var folder = await getApplicationDocumentsDirectory();
  File file = File(
      "${folder.path}/logs_${DateTime.now().toString().replaceAll(' ', '').replaceAll(':', '_')}.txt");
  await file.writeAsString("timestamp|x|y|pointer|down|move|up\n");
  runApp(MyApp(
    file: file,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.file});
  File file;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LogFile(
      logFile: file,
      mychild: MaterialApp(
        title: 'Public Display',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: HomePage(
          title: 'Public Display Home Page',
        ),
      ),
    );
  }
}
