import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  void popUntil(String routeName) {
    return navigatorKey.currentState!
        .popUntil((route) => route.settings.name == routeName);
  }

  void popAndPushNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState!.popAndPushNamed(routeName, arguments: arguments);
  }
}
