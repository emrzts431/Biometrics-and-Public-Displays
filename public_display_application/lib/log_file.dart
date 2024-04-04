import 'dart:io';

import 'package:flutter/material.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/models/preferences/preference.dart';
import 'package:public_display_application/models/user.dart';
import 'package:sqlite_async/sqlite_async.dart';

class LogFile extends InheritedWidget {
  final File logFile;
  final SqliteDatabase db;
  final List<String> _inputList = [];
  LogFile({required this.logFile, required this.db, required Widget mychild})
      : super(child: mychild);

  static LogFile of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<LogFile>() as LogFile;

  Future logInput(int x, int y, int pointer, String type) async {
    List<String> typeVals = type.split(',');
    String logString =
        "${DateTime.now().microsecondsSinceEpoch}\t$x\t$y\t$pointer\t${typeVals[0]}\t${typeVals[1]}\t${typeVals[2]}\n";
    _inputList.add(logString);
    debugPrint(logString);
    if (_inputList.length > 100) {
      print("dumping");
      String finalString = "";
      for (final line in _inputList) {
        finalString += line;
      }
      _inputList.clear();
      await logFile.writeAsString(
        finalString,
        mode: FileMode.append,
      );
    }
  }

  Future forceDumpInputs() async {
    if (_inputList.isNotEmpty) {
      print("force dumping");
      String finalString = "";
      for (final line in _inputList) {
        finalString += line;
      }
      _inputList.clear();
      await logFile.writeAsString(
        finalString,
        mode: FileMode.append,
      );
    } else {
      debugPrint("no inputs in list");
    }
  }

  Future<User?> selectUser(String surname, int age, Genders gender) async {
    try {
      final result = await db.get(
          "Select * from Users where substr(surname, 1, 3) = '$surname' and age = $age and gender = ${gender.index}");
      if (result.isNotEmpty) {
        //gender == 1 ? male : female
        return User(
          age: result['age'],
          gender: result['gender'] as int,
          surname: result['surname'],
          userid: result['userid'],
          name: result['name'],
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

  Future<bool> insertUser(
      String name, String surname, int age, Genders gender) async {
    try {
      await db.writeTransaction(
        (tx) async => await tx.execute(
          "Insert Into Users (age, name, surname, gender) Values (?,?,?,?)",
          [age, name, surname, gender.index],
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
            type.index,
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

  Future<int> getNumberOfVisitsForUser(int userid) async {
    try {
      final result = await db.get(
          'Select count(*) as ses from Session where userid = ? and type = 1',
          [userid]);
      if (result.isNotEmpty) {
        return result['ses'];
      } else {
        return 0;
      }
    } on StateError catch (e) {
      print(e);
      return 0;
    } on Error catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  bool updateShouldNotify(LogFile oldWidget) {
    return oldWidget.logFile != logFile || oldWidget.db != db;
  }
}
