import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/pages/home_page.dart';
import 'package:public_display_application/log_file.dart';
import 'package:public_display_application/navigation_service.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
import 'package:sqlite_async/sqlite_async.dart';

final migrations = SqliteMigrations()
  ..add(SqliteMigration(1, (tx) async {
    await tx.execute(
        'CREATE TABLE Users(userid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, age INTEGER, surname VARCHAR(50), gender INTEGER);');
    await tx.execute(
        'CREATE TABLE Preference(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, type INTEGER, userid INTEGER, value VARCHAR(300), FOREIGN KEY (userid) REFERENCES Users(userid));');
    await tx.execute(
        'CREATE TABLE Session(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, type INTEGER, userid INTEGER, time INTEGER, FOREIGN KEY (userid) REFERENCES Users(userid));');
  }));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var folder = await getApplicationDocumentsDirectory();
  final db = SqliteDatabase(path: '${folder.path}/pd.db');
  migrations.migrate(db);
  File file = File(
      "${folder.path}/logs_${DateTime.now().toString().replaceAll(' ', '').replaceAll(':', '_')}.tsv");
  await file.writeAsString("timestamp\tx\ty\tpointer\tdown\tmove\tup\n");
  runZonedGuarded(
      () => runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<UserViewModel>(
                  create: (_) => UserViewModel(),
                ),
                ChangeNotifierProvider<SessionViewModel>(
                  create: (_) => SessionViewModel(),
                ),
              ],
              child: MyApp(
                db: db,
                file: file,
              ),
            ),
          ), (error, stack) {
    print(error);
    print(stack);
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.file, required this.db});
  File file;
  SqliteDatabase db;

  // This widget is the root of your application.
  @override
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = NavigationService();
    return LogFile(
      db: widget.db,
      logFile: widget.file,
      mychild: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('de', 'DE'),
          Locale('en', 'EN')
        ],
        locale: const Locale('de', 'DE'),
        title: 'Public Display',
        navigatorKey: navigationService.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: HomePage(title: "Public Display"),
      ),
    );
  }
}
