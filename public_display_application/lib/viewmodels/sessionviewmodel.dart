import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';
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

  void updateLastTouch() {
    _lastTouch = DateTime.now();
    if (_coffeScreen && !_loginScreen) {
      _openLoginScreen();
    }
    notifyListeners();
  }

  void periodicChecks(BuildContext context) {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_lastTouch != null) {
        if (_contentScreen) {
          //If a valid user session exists
          if (DateTime.now().difference(_lastTouch!).inMinutes > 1) {
            await context.read<UserViewModel>().signOut();
            _lastTouch = null;
            _openCoffeeScreen();
            notifyListeners();
          }
        } else if (_loginScreen) {
          //If no valid session exists but user interacted with the screen
          if (DateTime.now().difference(_lastTouch!).inMinutes > 1) {
            _openCoffeeScreen();
            notifyListeners();
          }
        }
      }
    });
  }

  _openCoffeeScreen() {
    _coffeScreen = true;
    _contentScreen = false;
    _loginScreen = false;
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
