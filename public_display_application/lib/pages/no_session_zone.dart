import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/pages/welcome_page.dart';
import 'package:public_display_application/pages/login_page.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class NoSessionZone extends StatefulWidget {
  @override
  createState() => NoSessionZoneState();
}

class NoSessionZoneState extends State<NoSessionZone> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ModalRoute.of(context)?.isCurrent != true) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      }
      debugPrint("Currently at NoSessionZone");
      context.read<UserViewModel>().setHomePageContext(context);
      context.read<SessionViewModel>().startRestartPeriodicChecks(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<SessionViewModel>().coffeScreen) {
      return const WelcomePage();
    } else {
      return LoginPage();
    }
  }
}
