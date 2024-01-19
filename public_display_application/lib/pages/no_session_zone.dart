import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/pages/free_coffee_page.dart';
import 'package:public_display_application/pages/login_page.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';

class NoSessionZone extends StatefulWidget {
  @override
  createState() => NoSessionZoneState();
}

class NoSessionZoneState extends State<NoSessionZone> {
  @override
  Widget build(BuildContext context) {
    if (context.watch<SessionViewModel>().coffeScreen) {
      return FreeCoffeePage();
    } else {
      return LoginPage();
    }
  }
}
