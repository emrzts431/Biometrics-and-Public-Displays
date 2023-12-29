import 'package:flutter/material.dart';
import 'package:public_display_application/models/transportline_item.dart';

class TransportTimes extends StatelessWidget {
  TransportLineItem item;

  TransportTimes({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.realDateTime != null) {
      if (item.realDateTime == item.dateTime) {
        return Text(setUpTimeString(item.dateTime!));
      } else {
        return Column(
          children: [
            Text(
              setUpTimeString(item.dateTime!),
              style: const TextStyle(decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              setUpTimeString(item.realDateTime!),
            ),
          ],
        );
      }
    } else {
      return Column(
        children: [
          Text(
            setUpTimeString(item.dateTime!),
            style: const TextStyle(decoration: TextDecoration.lineThrough),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            item.realtimeTripStatus == TransportStatus.tripCancelled
                ? "Cancelled"
                : "Unknown Problem",
          ),
        ],
      );
    }
  }

  String setUpTimeString(DateTime time) {
    return "${time.hour < 10 ? "0${time.hour}" : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute}";
  }
}
