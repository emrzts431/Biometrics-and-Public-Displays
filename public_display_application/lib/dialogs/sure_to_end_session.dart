import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/navigation_service.dart';
import 'package:public_display_application/viewmodels/sessionviewmodel.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';

class SureToEndSessionDialog extends StatelessWidget {
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
            const Text(
              'Sicher, dass du dein Session enden willst ? Du kannst dein freie Kaffe nicht haben, wenn du jetzt endest!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () async {
                context.read<SessionViewModel>().openCoffeeScreen();
                await context.read<UserViewModel>().signOut();
                Navigator.pop(context);
              },
              child: const Text(
                'Session beenden',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        )),
      ),
    );
  }
}
