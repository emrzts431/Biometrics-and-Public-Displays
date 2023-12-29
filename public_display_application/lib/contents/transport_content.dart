import 'package:flutter/material.dart';
import 'package:public_display_application/models/transportline_item.dart';
import 'package:public_display_application/widgets/transport/transport_icon.dart';
import 'package:public_display_application/widgets/transport/transport_times.dart';

class TransportContent extends StatefulWidget {
  List<TransportLineItem> data;
  TransportContent({super.key, required this.data});

  @override
  State<StatefulWidget> createState() {
    return TransportContentState();
  }
}

class TransportContentState extends State<TransportContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.data.length,
        itemExtent: 100,
        itemBuilder: (context, index) {
          TransportLineItem item = widget.data[index];
          return ListTile(
            leading: TransportTimes(
              item: item,
            ),
            title: Row(
              children: [
                TransportIcon(type: item.transportType),
                const SizedBox(
                  width: 7,
                ),
                Text("${item.number}"),
              ],
            ),
            subtitle: Text(item.direction),
            trailing: Text(item.platformName),
          );
        },
      ),
    );
  }
}
