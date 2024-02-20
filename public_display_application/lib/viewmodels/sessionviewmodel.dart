import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class SessionViewModel extends ChangeNotifier {
  DateTime? _lastTouch;
  DateTime? get lastTouch => _lastTouch;

  bool _contentScreen = true;
  bool get contentScreen => _contentScreen;

  bool _loginScreen = false;
  bool get loginScreen => _loginScreen;

  bool _coffeScreen = true;
  bool get coffeScreen => _coffeScreen;

  Timer? periodicCheckTimer;
  bool _dialogOpen = false;

  void updateLastTouch() {
    _lastTouch = DateTime.now();
    if (_coffeScreen && !_loginScreen) {
      _openLoginScreen();
    }
    notifyListeners();
  }

  void periodicChecks(BuildContext context) {
    periodicCheckTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        if (_lastTouch != null) {
          if (_contentScreen) {
            //If a valid user session exists
            if (DateTime.now().difference(_lastTouch!).inSeconds >= 30) {
              if (!_dialogOpen) {
                _dialogOpen = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Dialog(
                      child: Container(
                    height: 250,
                    width: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).areYouStillThere,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updateLastTouch();
                              _dialogOpen = false;
                              Navigator.of(context).pop();
                            },
                            child: Text(S.of(context).yes),
                          ),
                        ],
                      ),
                    ),
                  )),
                );
              }
            }
            if (DateTime.now().difference(_lastTouch!).inSeconds >= 60) {
              Navigator.of(context).pop();

              await context.read<UserViewModel>().signOut();
              _lastTouch = null;
              openCoffeeScreen();
              notifyListeners();
            }
          } else if (_loginScreen) {
            //If no valid session exists but user interacted with the screen
            if (DateTime.now().difference(_lastTouch!).inSeconds > 30) {
              openCoffeeScreen();
              notifyListeners();
            }
          }
        }
      } on FlutterError catch (e) {
        print(e);
        _lastTouch = null;
        //await context.read<UserViewModel>().signOut();
        openCoffeeScreen();
        notifyListeners();
      }
    });
  }

  startRestartPeriodicChecks(BuildContext context) {
    if (periodicCheckTimer == null) {
      //no running timer, start one
      periodicChecks(context);
    } else {
      //timer running restart it
      periodicCheckTimer!.cancel();
      periodicCheckTimer = null;
      periodicChecks(context);
    }
  }

  openCoffeeScreen() {
    _coffeScreen = true;
    _contentScreen = false;
    _loginScreen = false;
    notifyListeners();
  }

  _openLoginScreen() {
    _coffeScreen = false;
    _contentScreen = false;
    _loginScreen = true;
  }

  openContentScreen() {
    _coffeScreen = false;
    _contentScreen = true;
    _loginScreen = false;
    notifyListeners();
  }
}
