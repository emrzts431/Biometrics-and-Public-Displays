import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VersionOneButtonLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 15, // Spacing between columns
        mainAxisSpacing: 15.0, // Spacing between rows
        childAspectRatio: 1.1,
      ),
      itemCount: 4, // Number of items in the grid
      itemBuilder: (BuildContext context, int index) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () => buttonFunctionality(index),
          child: Text(
            buttonName(index),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  void buttonFunctionality(int index) {
    switch (index) {
      case 0:
        print("Mensa");
      case 1:
        print("Transport");
      case 2:
        print("Map");
      case 3:
        print("Weather");
      default:
        print("WTF?");
    }
  }

  String buttonName(int index) {
    switch (index) {
      case 0:
        return "Mensa";
      case 1:
        return "Transport";
      case 2:
        return "Map";
      case 3:
        return "Weather";
      default:
        return "Unknown";
    }
  }

  void openWebView(int index) {}
}
