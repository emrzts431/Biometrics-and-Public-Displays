import 'dart:io';

import 'package:flutter/material.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/models/user.dart';
import 'package:public_display_application/navigation_service.dart';
import 'package:public_display_application/snackbar_holder.dart';
import 'package:sqlite_async/sqlite_async.dart';

class LogFile extends InheritedWidget {
  final File logFile;
  final SqliteDatabase db;

  LogFile({required this.logFile, required this.db, required Widget mychild})
      : super(child: mychild);

  static LogFile of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<LogFile>() as LogFile;

  void logInput(int x, int y, int pointer, String type, int contentid) {
    String logString =
        "${DateTime.now().microsecondsSinceEpoch},$x,$y,$pointer,$type\n";

    print(logFile);
    print(logString);
    logFile.writeAsString(
      logString,
      mode: FileMode.append,
    );
  }

  Future<User?> selectUser(String surname, int age, Genders gender) async {
    try {
      final result = await db.get(
          "Select * from Users where surname = '$surname' and age = $age and gender = ${gender == Genders.male ? 1 : 0}");
      if (result.isNotEmpty) {
        //gender == 1 ? male : female
        return User(
          age: result['age'],
          gender: result['gender'] == 1 ? true : false,
          surname: result['surname'],
          userid: result['userid'],
        );
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> insertUser(String surname, int age, Genders gender) async {
    try {
      await db.writeTransaction(
        (tx) async => await tx.execute(
          "Insert Into Users (age, surname, gender) Values (?,?,?)",
          [age, surname, gender == Genders.male ? 1 : 0],
        ),
      );
      return true;
    } on Exception catch (e) {
      print(e);

      return false;
    }
  }

  Future<bool> insertSession(
      SessionActionType type, int userid, int time) async {
    try {
      await db.writeTransaction(
        (tx) async => await tx.execute(
          "Insert Into Session (type, userid, time) Values (?, ?, ?)",
          [
            type == SessionActionType.start ? 1 : 0,
            userid,
            time,
          ],
        ),
      );
      return true;
    } on Exception catch (e) {
      print(e);

      return false;
    }
  }

  //TODO: Get preferences

  //TODO: Insert preferences

  @override
  bool updateShouldNotify(LogFile oldWidget) {
    return oldWidget.logFile != logFile || oldWidget.db != db;
  }
}
