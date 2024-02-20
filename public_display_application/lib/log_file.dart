import 'dart:io';

import 'package:flutter/material.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/models/preferences/preference.dart';
import 'package:public_display_application/models/user.dart';
import 'package:sqlite_async/sqlite_async.dart';

class LogFile extends InheritedWidget {
  final File logFile;
  final SqliteDatabase db;

  LogFile({required this.logFile, required this.db, required Widget mychild})
      : super(child: mychild);

  static LogFile of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<LogFile>() as LogFile;

  void logInput(int x, int y, int pointer, String type, int contentid) async {
    List<String> typeVals = type.split(',');
    String logString =
        "${DateTime.now().microsecondsSinceEpoch}\t$x\t$y\t$pointer\t${typeVals[0]}\t${typeVals[1]}\t${typeVals[2]}\n";

    print(logFile);
    print(logString);
    await logFile.writeAsString(
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
    } on StateError catch (e) {
      print(e);
      return null;
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

  Future<Preference?> getPreference(
      PreferenceTypes preferenceType, int userid) async {
    try {
      // 0: mensa, 1: weather, 2: transport, 3: map
      final result = await db.getAll(
        'Select value from Preference where userid = ? and type = ?',
        [
          userid,
          preferenceType.index,
        ],
      );
      if (result.isNotEmpty) {
        switch (preferenceType.index) {
          case 0:
            Preference mensaPreference =
                Preference(type: PreferenceTypes.mensa);
            for (final item in result) {
              mensaPreference.values.add(item['value']);
            }
            return mensaPreference;
          case 1:
            Preference transportPreference =
                Preference(type: PreferenceTypes.transport);
            for (final item in result) {
              transportPreference.values.add(item['value']);
            }
            return transportPreference;
          case 2:
            Preference weatherPreference =
                Preference(type: PreferenceTypes.weather);
            for (final item in result) {
              weatherPreference.values.add(item['value']);
            }
            return weatherPreference;
          case 3:
            Preference mapPreference = Preference(type: PreferenceTypes.map);
            for (final item in result) {
              mapPreference.values.add(item['value']);
            }
            return mapPreference;
          default:
            return null;
        }
      } else {
        return null;
      }
    } on StateError catch (e) {
      print(e);
      return null;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> insertPreference(
      PreferenceTypes type, int userid, String value) async {
    try {
      await db.writeTransaction(
        (tx) async => await tx.execute(
          "Insert Into Preference (type, userid, value) Values (?, ?, ?)",
          [
            type.index,
            userid,
            value,
          ],
        ),
      );
      return true;
    } on Exception catch (e) {
      print(e);

      return false;
    }
  }

  Future<bool> removePreference(
      PreferenceTypes type, int userid, String value) async {
    try {
      await db.writeTransaction((tx) async => await tx.execute(
            'Delete From Preference where type = ? and userid = ? and value = ?',
            [
              type.index,
              userid,
              value,
            ],
          ));
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeAllPreferencesOfType(
      PreferenceTypes type, int userid) async {
    try {
      await db.writeTransaction((tx) async => await tx.execute(
          'Delete from Preference where type = ? and userid = ?',
          [type.index, userid]));
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  @override
  bool updateShouldNotify(LogFile oldWidget) {
    return oldWidget.logFile != logFile || oldWidget.db != db;
  }
}
