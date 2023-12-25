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
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}
