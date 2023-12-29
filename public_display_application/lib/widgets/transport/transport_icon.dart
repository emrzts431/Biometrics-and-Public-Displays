import 'package:flutter/material.dart';
import 'package:public_display_application/models/transportline_item.dart';

class TransportIcon extends StatelessWidget {
  TransportType type;

  TransportIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == TransportType.bus) {
      return Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 139, 18, 97),
          borderRadius: BorderRadius.all(
            Radius.circular(
              25,
            ),
          ),
        ),
        child: const Center(
          child: Text(
            "BUS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 190, 20, 20),
        ),
        child: const Center(
          child: Text(
            "Tram",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      );
    }
  }
}
