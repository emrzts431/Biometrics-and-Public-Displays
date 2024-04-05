import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/events/button_click_event.dart';
import 'package:public_display_application/events/pd_event_bus.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/services/navigation_service.dart';
import 'package:public_display_application/services/service_locator.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class SureToEndSessionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      child: SizedBox(
        height: 800,
        width: 900,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   S.of(context).sureToEndSession,
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 100,
            // ),
            ElevatedButton(
              onPressed: () async {
                PDEventBus().fire(
                  ButtonClickedEvent(Buttons.endSessionYes.index),
                );
                context.read<SessionViewModel>().openCoffeeScreen();
                await context.read<UserViewModel>().signOut();
                Navigator.pop(
                  locator<NavigationService>().navigatorKey.currentContext!,
                );
              },
              child: Text(
                S.of(context).endSession,
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        )),
      ),
    );
  }
}
