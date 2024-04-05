import 'package:desktop_webview_window/desktop_webview_window.dart';
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

class SUSForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      child: Container(
        height: 800,
        width: 900,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).susForm,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () async {
                PDEventBus().fire(
                  ButtonClickedEvent(Buttons.goSUS.index),
                );
                const createConfig = CreateConfiguration(openMaximized: true);
                final webview =
                    await WebviewWindow.create(configuration: createConfig);

                webview.launch(
                    "https://docs.google.com/forms/d/e/1FAIpQLSeTTV_KJLZLyE61Vx61dfY-J4bRLgYOP2EaQeAKtc0S0CrSLA/viewform?usp=sf_link");
                locator<NavigationService>()
                    .navigatorKey
                    .currentContext!
                    .read<SessionViewModel>()
                    .openCoffeeScreen();
                await Provider.of<UserViewModel>(
                  locator<NavigationService>().navigatorKey.currentContext!,
                  listen: false,
                ).signOut();
              },
              child: Text(
                S.of(context).gotoSusForm,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 110,
            ),
            TextButton(
              onPressed: () {
                PDEventBus().fire(
                  ButtonClickedEvent(Buttons.exitSUS.index),
                );
                Navigator.pop(context);
              },
              child: Text(S.of(context).exit),
            ),
          ],
        )),
      ),
    );
  }
}
